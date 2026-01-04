"""
CRUD operations for User collection.
"""

import logging
import re
from typing import Optional, List, Tuple
from pymongo.collection import ReturnDocument

from app.db.db import User as UserCollection
from app.schemas.user import UserCreate, UserUpdate


logger = logging.getLogger(__name__)


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
        sort_by: Optional[str] = "name",
        order: Optional[str] = "asc"
    ) -> List[dict]:
        """Get multiple users with optional filters and sorting."""
        query = {}
        
        if start_year_gte is not None:
            query["start_year"] = {"$gte": start_year_gte}
            
        if year is not None:
             query["start_year"] = year
        
        if patrao_id is not None:
            query["patrao_id"] = patrao_id
            
        if role_id:
            # First find users with this role in user_roles
            from app.db.db import UserRole
            # Use regex to allow filtering by parent organization (prefix match)
            # role_id ".1." should match ".1.2." etc.
            query_filter = {"role_id": {"$regex": f"^{re.escape(role_id)}"}}
            user_ids = [
                ur["user_id"] 
                for ur in UserRole.find(query_filter)
            ]
            query["_id"] = {"$in": user_ids}
        
        if search:
            search = search.strip()
            # Build $or query for multi-field search
            or_conditions = [
                # Name: case-insensitive partial match
                {"name": {"$regex": search, "$options": "i"}}
            ]
            # If search is numeric, also search by _id and nmec
            if search.isdigit():
                search_int = int(search)
                or_conditions.append({"_id": search_int})
                or_conditions.append({"nmec": search_int})
            
            # Use $and if we already have query constraints (like role_id filter)
            if query:
                # If query already has keys, we need to respect them by putting relevant logic properly
                pass # Handled below
            
            # If we have an existing _id constraint (from role_id), we must merge or use $and
            if "_id" in query:
                query["$and"] = [
                    {"$or": or_conditions}
                ]
            else:
                 query["$or"] = or_conditions
        
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
            {"$lookup": {
                "from": "user_roles",
                "localField": "_id",
                "foreignField": "user_id",
                "as": "user_roles"
            }}
        ]
        
        results = list(self.collection.aggregate(pipeline))
        
        # Enrich roles with org_name for frontend display
        if results:
            org_short_map = self._build_org_short_map()
            for user in results:
                updated_roles = []
                for role in user.get("user_roles", []):
                    try:
                        if "_id" in role:
                            role["_id"] = str(role["_id"])
                        if not role.get("org_name"):
                            role["org_name"] = self._get_org_short(role.get("role_id"), org_short_map)
                        
                        # Add format info
                        role_id_key = role.get("role_id")
                        # Robust lookup for role_name (handle trailing dots mismatch)
                        lookup_key = role_id_key
                        if lookup_key not in org_short_map:
                            if lookup_key.endswith("."):
                                diff_key = lookup_key.rstrip(".")
                                if diff_key in org_short_map:
                                    lookup_key = diff_key
                            else:
                                diff_key = lookup_key + "."
                                if diff_key in org_short_map:
                                    lookup_key = diff_key

                        if lookup_key in org_short_map:
                             # Use specific role name
                             role["role_name"] = org_short_map[lookup_key].get("name")
                             role["year_display_format"] = org_short_map[lookup_key].get("format", "civil")
                             role["icon"] = org_short_map[lookup_key].get("icon")
                             role["hidden"] = org_short_map[lookup_key].get("hidden", False)
                        else:
                             # Fallback to org_name if specific role is truly not found
                             role["role_name"] = role.get("org_name")
                             role["year_display_format"] = "civil"
                             role["hidden"] = False

                        updated_roles.append(role)
                    except Exception as e:
                        print(f"Error processing role for user {user.get('_id')}: {e}")
                        continue
                user["user_roles"] = updated_roles
                        
        return results
    
    def get_children(self, patrao_id: int) -> List[dict]:
        """Get all users with given patrao_id (pedaços)."""
        return list(self.collection.find({"patrao_id": patrao_id}))
    
    def count(
        self, 
        query: dict = None,
        search: Optional[str] = None,
        year: Optional[int] = None,
        role_id: Optional[str] = None
    ) -> int:
        """Count users matching query."""
        q = query.copy() if query else {}
        
        if year is not None:
             q["start_year"] = year
             
        if role_id:
            # First find users with this role in user_roles
            from app.db.db import UserRole
            query_filter = {"role_id": {"$regex": f"^{re.escape(role_id)}"}}
            user_ids = [
                ur["user_id"] 
                for ur in UserRole.find(query_filter)
            ]
            # Handle potential conflict if _id is already filtered (unlikely for count but safe to handle)
            if "_id" in q:
                # Intersect existing IDs with role IDs
                # BUT $in takes a list. Complex.
                # Simplified: assumes q doesn't have _id constraint yet or we overwrite it cautiously.
                # For safety, let's use $and if needed.
                q["$and"] = [
                    {"_id": {"$in": user_ids}},
                    {"_id": q["_id"]}
                ]
                del q["_id"]
            else:
                q["_id"] = {"$in": user_ids}

        if search:
            search = search.strip()
            or_conditions = [
                {"name": {"$regex": search, "$options": "i"}}
            ]
            if search.isdigit():
                search_int = int(search)
                or_conditions.append({"_id": search_int})
                or_conditions.append({"nmec": search_int})
            
            if "_id" in q:
                 q["$and"] = [
                    {"$or": or_conditions}
                ]
            else:
                q["$or"] = or_conditions
                
        return self.collection.count_documents(q)
    
    def get_all(self) -> List[dict]:
        """Get all users."""
        return list(self.collection.find())
    
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
        """Build a map of role_id paths to org info (short name, format)."""
        from app.db.db import Role
        # Fetch all roles to have complete lookup
        roles = list(Role.find({}))
        # Store short name (for organization inheritance), format, AND full name (for specific title)
        return {r["_id"]: {
            "short": r.get("short"), 
            "format": r.get("year_display_format", "civil"),
            "name": r.get("name"),
            "icon": r.get("icon"),
            "hidden": r.get("hidden", False)
        } for r in roles}
    
    def _get_org_short(self, role_id: str, org_map: dict) -> Optional[str]:
        """
        Get org short name for a role_id by traversing up the hierarchy.
        role_id format: ".1.5.9." means Faina > CF > Mestre de Curso
        We need to find the first parent that has a short name.
        """
        if not role_id:
            return None
        
        # Try exact match first - ONLY if it has a short name
        if role_id in org_map and org_map[role_id]["short"]:
            return org_map[role_id]["short"]
        
        # Traverse up the hierarchy
        # ".1.5.9." -> [".1.5.", ".1."]
        parts = role_id.rstrip('.').split('.')
        for i in range(len(parts) - 1, 0, -1):
            parent_path = '.'.join(parts[:i]) + '.'
            if parent_path in org_map and org_map[parent_path]["short"]:
                return org_map[parent_path]["short"]
        
        return None

    
    def _build_tree(self) -> Tuple[dict, List[dict], int]:
        """
        Build complete tree structure using MongoDB aggregation.
        Returns: (users_by_id, roots, total)
        """
        # Use aggregation to get sorted users with only needed fields
        # Use $addFields + $ifNull to ensure nulls sort to end (consistent with Python)
        pipeline = [
            {"$addFields": {
                "_sort_year": {"$ifNull": ["$start_year", 9999]}
            }},
            {"$sort": {"_sort_year": 1}},
            # Lookup user roles
            {"$lookup": {
                "from": "user_roles",
                "localField": "_id",
                "foreignField": "user_id",
                "as": "user_roles"
            }},
            {"$project": {
                "_id": 1,
                "name": 1,
                "faina_name": 1,
                "sex": 1,
                "start_year": 1,
                "end_year": 1,
                "nmec": 1,
                "course_id": 1,
                "patrao_id": 1,
                "user_roles": {
                    "role_id": 1,
                    "year": 1,
                    "org_name": 1
                }
            }}
        ]
        
        all_users = list(self.collection.aggregate(pipeline))
        total = len(all_users)
        
        if total == 0:
            return {}, [], 0
        
        # Build role short name lookup (fallback for roles without org_name)
        org_short_map = self._build_org_short_map()
        
        # Add org_name if not already present from DB
        for user in all_users:
            for role in user.get("user_roles", []):
                if not role.get("org_name"):
                    role_id = role.get("role_id", "")
                    role["org_name"] = self._get_org_short(role_id, org_short_map)
                
                # Add role_name and format logic here too (duplicate of get_multi but necessary for Tree)
                role_id_key = role.get("role_id")
                # Robust lookup for role_name
                lookup_key = role_id_key
                if lookup_key not in org_short_map:
                    if lookup_key.endswith("."):
                        diff_key = lookup_key.rstrip(".")
                        if diff_key in org_short_map:
                            lookup_key = diff_key
                    else:
                        diff_key = lookup_key + "."
                        if diff_key in org_short_map:
                            lookup_key = diff_key

                if lookup_key in org_short_map:
                        role["role_name"] = org_short_map[lookup_key].get("name")
                        role["year_display_format"] = org_short_map[lookup_key].get("format", "civil")
                        role["icon"] = org_short_map[lookup_key].get("icon")
                        role["hidden"] = org_short_map[lookup_key].get("hidden", False)
                else:
                        role["role_name"] = role.get("org_name")
                        role["year_display_format"] = "civil"
                        role["hidden"] = False
        
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
