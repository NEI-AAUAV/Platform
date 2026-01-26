"""
CRUD operations for User collection.
"""

import logging
import re
from typing import Optional, List, Tuple
from pymongo.collection import ReturnDocument

from app.db.db import User as UserCollection
from app.schemas.user import UserCreate, UserUpdate
from app.services.storage import storage_client
from app.core.config import settings
from app.constants import INFINITY_SORT_VALUE
from PIL import Image, ImageOps
from io import BytesIO
from hashlib import md5
import base64


logger = logging.getLogger(__name__)

MONGO_REGEX = "$regex"
MONGO_LOOKUP = "$lookup"


class CRUDUser:
    """CRUD operations for User collection."""
    
    def __init__(self):
        self.collection = UserCollection
    
    def get(self, id: int) -> Optional[dict]:
        """Get user by ID."""
        return self.collection.find_one({"_id": id})
    
    def get_by_nmec(self, nmec: int) -> Optional[dict]:
        """Get user by nmec (número mecanográfico)."""
        return self.collection.find_one({"nmec": nmec})
    
    def _build_common_query(
        self, 
        base_query: Optional[dict] = None,
        *,
        start_year_gte: Optional[int] = None,
        year: Optional[int] = None,
        patrao_id: Optional[int] = None,
        role_id: Optional[str] = None,
        role_year: Optional[int] = None,
        search: Optional[str] = None
    ) -> dict:
        """Build MongoDB query from common filters."""
        q = base_query.copy() if base_query else {}
        
        if start_year_gte is not None:
            q["start_year"] = {"$gte": start_year_gte}
            
        if year is not None:
             q["start_year"] = year
        
        if patrao_id is not None:
            q["patrao_id"] = patrao_id
            
        if role_id:
            # First find users with this role in user_roles
            from app.db.db import UserRole
            # Use regex to allow filtering by parent organization (prefix match)
            role_query = {"role_id": {MONGO_REGEX: f"^{re.escape(role_id)}"}}
            if role_year is not None:
                role_query["year"] = role_year
            user_ids = [ur["user_id"] for ur in UserRole.find(role_query)]
            
            # Merge with existing constraints
            if "_id" in q:
                 q.setdefault("$and", []).append({"_id": {"$in": user_ids}})
            else:
                q["_id"] = {"$in": user_ids}
        
        if search:
            search = search.strip()
            # Build $or query for multi-field search
            or_conditions = [
                {"name": {MONGO_REGEX: search, "$options": "i"}}
            ]
            # If search is numeric, also search by _id and nmec
            if search.isdigit():
                search_int = int(search)
                or_conditions.append({"_id": search_int})
                or_conditions.append({"nmec": search_int})
            
            if "$or" in q:
                 q.setdefault("$and", []).append({"$or": or_conditions})
            else:
                 q["$or"] = or_conditions
                 
        return q

    def get_multi(
        self, 
        *, 
        skip: int = 0, 
        limit: int = 100,
        start_year_gte: Optional[int] = None,
        patrao_id: Optional[int] = None,
        search: Optional[str] = None,
        year: Optional[int] = None,
        role_id: Optional[str] = None,
        role_year: Optional[int] = None,
        sort_by: Optional[str] = "name",
        order: Optional[str] = "asc"
    ) -> List[dict]:
        """Get multiple users with optional filters and sorting."""
        query = self._build_common_query(
            start_year_gte=start_year_gte,
            year=year,
            patrao_id=patrao_id,
            role_id=role_id,
            role_year=role_year,
            search=search
        )
        
        # Determine sort direction
        sort_dir = 1 if order == "asc" else -1
        
        # Map frontend sort keys to DB keys
        sort_field = sort_by
        if sort_by == "id":
            sort_field = "_id"
        elif sort_by == "year":
            sort_field = "start_year"
        elif sort_by not in ["name", "nmec", "_id", "start_year", "patrao_id"]:
            sort_field = "name" # Default fallback
            
        
        # Use aggregation to fetch users + roles
        pipeline = [
            {"$match": query},
            {"$sort": {sort_field: sort_dir}},
            {"$skip": skip},
            {"$limit": limit},
            {MONGO_LOOKUP: {
                "from": "user_roles",
                "localField": "_id",
                "foreignField": "user_id",
                "as": "user_roles"
            }}
        ]
        
        results = list(self.collection.aggregate(pipeline))
        
        # Enrich roles with org_name, role_name, icon, etc. for frontend display
        if results:
            org_short_map = self._build_org_short_map()
            for user in results:
                user_sex = user.get("sex")
                for role in user.get("user_roles", []):
                    try:
                        self._enrich_role(role, org_short_map, user_sex)
                    except (KeyError, TypeError) as e:
                        logger.warning(f"Error processing role for user {user.get('_id')}: {e}")
                        
        return results
    
    def get_children(self, patrao_id: int) -> List[dict]:
        """Get all users with given patrao_id (pedaços)."""
        return list(self.collection.find({"patrao_id": patrao_id}))
    
    def count(
        self, 
        query: dict = None,
        search: Optional[str] = None,
        year: Optional[int] = None,
        role_id: Optional[str] = None,
        role_year: Optional[int] = None
    ) -> int:
        """Count users matching query."""
        q = self._build_common_query(
            base_query=query,
            year=year,
            role_id=role_id,
            role_year=role_year,
            search=search
        )
        return self.collection.count_documents(q)
    
    def get_all(self) -> List[dict]:
        """Get all users."""
        return list(self.collection.find())

    async def update_image(self, user_id: int, image_bytes: bytes | None) -> Optional[dict]:
        """Update user image. If image_bytes is None, remove image."""
        user = self.get(user_id)
        if not user:
            return None

        new_url = None
        old_image = user.get("image")

        if image_bytes is not None:
            # Reject overly large uploads early
            if len(image_bytes) > 2 * 1024 * 1024:
                raise ValueError("Image must be under 2MB")

            try:
                img = Image.open(BytesIO(image_bytes))
            except Exception:
                raise ValueError("Invalid image")

            img = ImageOps.exif_transpose(img)
            img = img.convert("RGB")
            # Constrain to a sane size to save bandwidth/storage
            img.thumbnail((1200, 1200))
            buf = BytesIO()
            img.save(buf, format="JPEG", quality=85, optimize=True, progressive=True)
            data = buf.getvalue()
            digest = md5(data).hexdigest()
            key = f"family/users/{user_id}/{digest}.jpg"

            uploaded = storage_client.upload_image(key, data, "image/jpeg")
            if not uploaded:
                raise ValueError("Failed to upload image to R2 storage")
            new_url = uploaded
            
            # Delete old image from R2 if it's different from the new one
            if old_image and old_image != new_url:
                storage_client.delete_image(old_image)
        else:
            # Removing image - delete old one from R2
            if old_image:
                storage_client.delete_image(old_image)

        update_doc = {"$set": {"image": new_url}}
        updated = self.collection.find_one_and_update(
            {"_id": user_id},
            update_doc,
            return_document=ReturnDocument.AFTER,
        )
        return updated
    
    def get_roots(self) -> List[dict]:
        """Get users without patrão (root nodes of the tree)."""
        return list(self.collection.find({"patrao_id": None}))
    
    def get_year_range(self) -> tuple:
        """Get min and max start_year from users collection."""
        pipeline = [
            {"$match": {"start_year": {"$ne": None}}},
            {"$group": {
                "_id": None,
                "min_year": {"$min": "$start_year"},
                "max_year": {"$max": "$start_year"}
            }}
        ]
        result = list(self.collection.aggregate(pipeline))
        if result:
            return result[0]["min_year"], result[0]["max_year"]
        return 0, 0

    def get_years(self) -> List[int]:
        """Get distinct start_years present in DB, sorted descending."""
        years = self.collection.distinct("start_year")
        # Filter None and sort descending
        return sorted([y for y in years if y is not None], reverse=True)

    
    def _sort_key(self, x):
        """Sort key for tree nodes: None values sort to end."""
        start_year = x.get("start_year")
        return start_year if start_year is not None else float("inf")
    
    def _build_org_short_map(self) -> dict:
        """Build a map of role_id paths to org info (short name, format).
        
        Keys are path strings like '.1.7.13.' constructed from super_roles + _id.
        This matches the role_id format stored in user_roles collection.
        """
        from app.db.db import Role
        # Fetch all roles to have complete lookup
        roles = list(Role.find({}))
        
        result = {}
        for r in roles:
            # Construct path key: super_roles + _id + "."
            # e.g., super_roles=".1.7.", _id=13 -> path=".1.7.13."
            super_roles = r.get("super_roles", "")
            role_id = r["_id"]
            
            # Handle both string and integer _id
            if isinstance(role_id, int):
                path = f"{super_roles}{role_id}."
            else:
                # If _id is already a path string, use as-is
                path = str(role_id)
            
            result[path] = {
                "short": r.get("short"), 
                "format": r.get("year_display_format", "civil"),
                "name": r.get("name"),
                "female_name": r.get("female_name"),
                "icon": r.get("icon"),
                "hidden": r.get("hidden", False)
            }
        
        return result
    
    def _get_org_short(self, role_id: str, org_map: dict) -> Optional[str]:
        """
        Get org short name for a role_id by traversing up the hierarchy.
        role_id format: ".1.5.9." means Faina > CF > Mestre de Curso
        We need to find the first parent that has a short name.
        Falls back to role name if no short code is found anywhere in hierarchy.
        """
        if not role_id:
            return None
        
        # ALWAYS traverse up to find the best short code first
        # This ensures all NEI roles get "NEI", not their individual role names
        parts = role_id.rstrip('.').split('.')
        
        # Check from current level up to root for a short code
        for i in range(len(parts), 0, -1):
            path = '.'.join(parts[:i]) + '.'
            if path in org_map and org_map[path].get("short"):
                return org_map[path]["short"]
        
        # Fallback: if no short found anywhere, return the current role's name
        if role_id in org_map and org_map[role_id].get("name"):
            return org_map[role_id]["name"]
        
        return None

    def _get_immediate_parent_name(self, role_id: str, org_map: dict) -> Optional[str]:
        """
        Get the name of the immediate parent role (one level up).
        Used to show context like "Presidente (Direção)" vs "Presidente (RGM)".
        
        role_id format: ".1.5.9." -> parent is ".1.5."
        Returns the name of the parent role, or None if no parent or at root.
        """
        if not role_id:
            return None
        
        parts = role_id.rstrip('.').split('.')
        
        # Need at least 3 levels: ".1.5." -> parts = ["", "1", "5"]
        # Parent would be ".1." -> parts[:2] = ["", "1"]
        if len(parts) <= 2:
            return None  # At root or too shallow
        
        # Get parent path (one level up)
        parent_path = '.'.join(parts[:-1]) + '.'
        
        if parent_path in org_map:
            parent_info = org_map[parent_path]
            # Return short if exists, otherwise name
            return parent_info.get("short") or parent_info.get("name")
        
        return None

    def _get_inherited_hidden(self, role_id: str, org_map: dict) -> bool:
        """
        Check if a specific role is hidden.
        Visibility is INDEPENDENT - does NOT inherit from parent roles.
        """
        if not role_id:
            return False
        
        # Check exact match only
        if role_id in org_map:
            # Normalize None to False
            hidden = org_map[role_id].get("hidden")
            return hidden if hidden is not None else False
        
        # Try with/without trailing dot for consistency
        alt_key = role_id.rstrip('.') if role_id.endswith('.') else role_id + '.'
        if alt_key in org_map:
            hidden = org_map[alt_key].get("hidden")
            return hidden if hidden is not None else False
        
        return False

    def _get_inherited_icon(self, role_id: str, org_map: dict) -> Optional[str]:
        """
        Get icon for a role_id by traversing up the hierarchy.
        If a role doesn't have an icon, inherit from parent.
        role_id format: ".1.5.9." -> checks .1.5.9., .1.5., .1. in order
        """
        if not role_id:
            return None
        
        # Try exact match first
        if role_id in org_map:
            icon = org_map[role_id].get("icon")
            if icon:  # Has own icon
                return icon
        
        # Traverse up the hierarchy looking for an icon
        # ".1.5.9." -> [".1.5.", ".1."]
        parts = role_id.rstrip('.').split('.')
        for i in range(len(parts) - 1, 0, -1):
            parent_path = '.'.join(parts[:i]) + '.'
            parent_info = org_map.get(parent_path)
            if parent_info and parent_info.get("icon"):
                return parent_info["icon"]
        
        return None

    def _get_inherited_format(self, role_id: str, org_map: dict) -> str:
        """
        Get year_display_format for a role_id by traversing up the hierarchy.
        If a role doesn't define format, inherit from parent.
        role_id format: ".2.14." -> checks .2.14., .2. in order
        Returns: 'civil' or 'academic'
        """
        if not role_id:
            return "civil"
        
        # Try exact match first
        if role_id in org_map:
            fmt = org_map[role_id].get("format")
            if fmt:  # Has own format defined
                return fmt
        
        # Traverse up the hierarchy looking for format
        # ".2.14." -> [".2."]
        parts = role_id.rstrip('.').split('.')
        for i in range(len(parts) - 1, 0, -1):
            parent_path = '.'.join(parts[:i]) + '.'
            parent_info = org_map.get(parent_path)
            if parent_info and parent_info.get("format"):
                return parent_info["format"]
        
        return "civil"

    def _normalize_role_key(self, role_id: str, org_map: dict) -> str:
        """Normalize role_id to match org_map keys (handles trailing dot mismatch)."""
        if not role_id or role_id in org_map:
            return role_id
        
        # Try with/without trailing dot
        alt_key = role_id.rstrip('.') if role_id.endswith('.') else role_id + '.'
        return alt_key if alt_key in org_map else role_id


    def _resolve_role_name(self, role_info: dict, user_sex: Optional[str]) -> str:
        """Resolve role name, using female variant if applicable."""
        if user_sex == "F" and role_info.get("female_name"):
            return role_info["female_name"]
        return role_info.get("name")

    def _enrich_role(self, role: dict, org_map: dict, user_sex: str = None) -> None:
        """Enrich a single role dict with org_name, role_name, icon, hidden, format.
        
        Args:
            role: The role dict to enrich
            org_map: Map of role_id paths to role info
            user_sex: Sex of the user ('M' or 'F') for feminine role names
        """
        # Serialize ObjectId if present
        if "_id" in role:
            role["_id"] = str(role["_id"])
        
        role_id = role.get("role_id", "")
        
        # Ensure org_name is human-readable
        org_name = role.get("org_name")
        if not org_name or (isinstance(org_name, str) and org_name.startswith(".")):
            role["org_name"] = self._get_org_short(role_id, org_map)
        
        # Normalize role_id for lookup
        lookup_key = self._normalize_role_key(role_id, org_map)
        effective_id = lookup_key if lookup_key in org_map else role_id
        
        if lookup_key in org_map:
            role["role_name"] = self._resolve_role_name(org_map[lookup_key], user_sex)
        else:
            role["role_name"] = role.get("org_name")
            
        # Set inherited/computed properties using effective_id
        if effective_id:
            role["year_display_format"] = self._get_inherited_format(effective_id, org_map)
            role["icon"] = self._get_inherited_icon(effective_id, org_map)
            role["hidden"] = self._get_inherited_hidden(effective_id, org_map)
            role["parent_org_name"] = self._get_immediate_parent_name(effective_id, org_map)
        else:
            role["year_display_format"] = "civil"
            role["icon"] = None
            role["hidden"] = False
            role["parent_org_name"] = None

    
    def _build_tree(self) -> Tuple[dict, List[dict], int]:
        """
        Build complete tree structure using MongoDB aggregation.
        Returns: (users_by_id, roots, total)
        """
        # Use aggregation to get sorted users with only needed fields
        # Use $addFields + $ifNull to ensure nulls sort to end (consistent with Python)
        pipeline = [
            {"$addFields": {
                "_sort_year": {"$ifNull": ["$start_year", INFINITY_SORT_VALUE]}
            }},
            {"$sort": {"_sort_year": 1}},
            # Lookup user roles with nested lookup to get role details including hidden
            {MONGO_LOOKUP: {
                "from": "user_roles",
                "localField": "_id",
                "foreignField": "user_id",
                "as": "user_roles",
                "pipeline": [
                    # For each user_role, lookup the role details
                    {MONGO_LOOKUP: {
                        "from": "roles",
                        "localField": "role_id",
                        "foreignField": "_id",
                        "as": "role_details"
                    }},
                    {"$unwind": {"path": "$role_details", "preserveNullAndEmptyArrays": True}},
                    {"$addFields": {
                        "hidden": {"$ifNull": ["$role_details.hidden", False]},
                        "role_name": "$role_details.name",
                        "icon": "$role_details.icon",
                        "year_display_format": {"$ifNull": ["$role_details.year_display_format", "civil"]},
                        "org_name": {"$ifNull": ["$org_name", "$role_details.short"]}
                    }},
                    {"$project": {
                        "role_id": 1,
                        "year": 1,
                        "org_name": 1,
                        "hidden": 1,
                        "role_name": 1,
                        "icon": 1,
                        "year_display_format": 1
                    }}
                ]
            }},
            {"$project": {
                "_id": 1,
                "name": 1,
                "faina_name": 1,
                "image": 1,
                "sex": 1,
                "start_year": 1,
                "end_year": 1,
                "nmec": 1,
                "course_id": 1,
                "patrao_id": 1,
                "user_roles": 1  # Already enriched with hidden, role_name, etc.
            }}
        ]
        
        all_users = list(self.collection.aggregate(pipeline))
        total = len(all_users)
        
        if total == 0:
            return {}, [], 0
        
        # Build role short name lookup (fallback for roles without org_name)
        org_short_map = self._build_org_short_map()
        
        # Enrich roles with org_name, role_name, icon, etc.
        for user in all_users:
            user_sex = user.get("sex")
            for role in user.get("user_roles", []):
                self._enrich_role(role, org_short_map, user_sex)
        
        # Create lookup dict by ID with children arrays
        users_by_id = {u["_id"]: {**u, "children": []} for u in all_users}
        
        # Build tree by assigning children to parents
        roots = []
        for user_id, user in users_by_id.items():
            patrao_id = user.get("patrao_id")
            if patrao_id is None:
                roots.append(user)
            elif patrao_id in users_by_id:
                users_by_id[patrao_id]["children"].append(user)
            else:
                # Orphaned user: patrao_id exists but not in DB
                logger.warning(f"Orphaned user {user_id}: patrao_id={patrao_id} not found")
                roots.append(user)  # Add as root to include in tree
        
        # Note: Children are already sorted since we sorted all_users first
        # Just need to sort roots (None start_year goes to end)
        roots.sort(key=self._sort_key)
        
        return users_by_id, roots, total
    
    def _apply_depth_limit(self, node: dict, current_depth: int, max_depth: int) -> dict:
        """Create a copy of node with depth-limited children."""
        result = {k: v for k, v in node.items() if k != "children"}
        
        if current_depth >= max_depth:
            children = node.get("children", [])
            result["children"] = []
            result["has_more_children"] = len(children) > 0
        else:
            result["children"] = [
                self._apply_depth_limit(child, current_depth + 1, max_depth)
                for child in node.get("children", [])
            ]
        
        return result
    
    def get_tree(
        self, 
        root_id: Optional[int] = None,
        depth: Optional[int] = None
    ) -> Tuple[List[dict], int]:
        """
        Build hierarchical family tree.
        
        Args:
            root_id: Optional user ID to start tree from (subtree)
            depth: Optional maximum depth to return (None = unlimited)
                   depth=0 returns only root(s)
                   depth=1 returns root(s) + direct children
        
        Returns:
            Tuple of (root_nodes_with_children, total_count)
        """
        users_by_id, roots, total = self._build_tree()
        
        # If root_id specified, get subtree
        if root_id is not None:
            if root_id not in users_by_id:
                return [], 0
            roots = [users_by_id[root_id]]
        
        # Apply depth limit if specified
        if depth is not None and depth >= 0:
            roots = [self._apply_depth_limit(root, 0, depth) for root in roots]
        
        # Count nodes in result
        def count_nodes(nodes):
            count = len(nodes)
            for node in nodes:
                count += count_nodes(node.get("children", []))
            return count
        
        # When depth-limited or using subtree, count actual returned nodes
        if depth is not None or root_id is not None:
            result_count = count_nodes(roots)
        else:
            result_count = total
        
        return roots, result_count
    
    def get_existing_ids(self, ids: List[int]) -> List[int]:
        """
        Batch lookup: return list of IDs that exist in the database.
        Much more efficient than calling exists() N times.
        """
        if not ids:
            return []
        result = self.collection.find(
            {"_id": {"$in": ids}},
            {"_id": 1}
        )
        return [doc["_id"] for doc in result]
    
    def check_cycle(self, target_user_id: int, new_patrao_id: int) -> bool:
        """
        Check if setting new_patrao_id as parent of target_user_id would create a cycle.
        Returns True if a cycle would be created (invalid), False otherwise.
        
        Example: If A -> B -> C, setting C as patrao of A would create cycle.
        """
        if new_patrao_id is None:
            return False  # No cycle if becoming root
        
        if target_user_id == new_patrao_id:
            return True  # Direct self-reference
        
        # Traverse up from new_patrao_id to check if we reach target_user_id
        visited = set()
        current_id = new_patrao_id
        
        while current_id is not None:
            if current_id in visited:
                # Already a cycle in existing data (shouldn't happen but safe)
                return True
            if current_id == target_user_id:
                return True  # Would create cycle
            
            visited.add(current_id)
            user = self.get(current_id)
            if not user:
                break  # User not found, no cycle possible
            current_id = user.get("patrao_id")
        
        return False
    
    def create(self, *, obj_in: UserCreate) -> dict:
        """Create new user."""
        # Get next ID
        max_doc = self.collection.find_one(sort=[("_id", -1)])
        next_id = (max_doc["_id"] + 1) if max_doc else 1
        
        # Prepare document
        doc = obj_in.dict()
        doc["_id"] = next_id
        
        # Auto-generate faina_name if not provided
        if not doc.get("faina_name"):
            doc["faina_name"] = doc["name"].split()[-1]  # Use last name
        
        self.collection.insert_one(doc)
        return self.get(next_id)
    
    def update(self, *, id: int, obj_in: UserUpdate) -> Optional[dict]:
        """Update user by ID."""
        update_data = obj_in.dict(exclude_unset=True)
        
        if not update_data:
            return self.get(id)
        
        result = self.collection.find_one_and_update(
            {"_id": id},
            {"$set": update_data},
            return_document=ReturnDocument.AFTER
        )
        return result
    
    def delete(self, *, id: int) -> bool:
        """Delete user by ID."""
        result = self.collection.delete_one({"_id": id})
        return result.deleted_count > 0
    
    def exists(self, id: int) -> bool:
        """Check if user exists."""
        return self.collection.count_documents({"_id": id}, limit=1) > 0


# Singleton instance
user = CRUDUser()
