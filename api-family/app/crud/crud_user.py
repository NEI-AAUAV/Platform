"""
CRUD operations for User collection.
"""

import time
from typing import Optional, List, Any, Tuple
from pymongo.collection import ReturnDocument

from app.db.db import User as UserCollection
from app.schemas.user import UserCreate, UserUpdate


# Simple in-memory cache for tree data
_tree_cache: dict = {
    "data": None,
    "timestamp": 0,
    "ttl": 60  # Cache TTL in seconds (1 minute)
}


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
        patrao_id: Optional[int] = None
    ) -> List[dict]:
        """Get multiple users with optional filters."""
        query = {}
        
        if start_year_gte is not None:
            query["start_year"] = {"$gte": start_year_gte}
        
        if patrao_id is not None:
            query["patrao_id"] = patrao_id
        
        cursor = self.collection.find(query).skip(skip).limit(limit)
        return list(cursor)
    
    def get_children(self, patrao_id: int) -> List[dict]:
        """Get all users with given patrao_id (pedaços)."""
        return list(self.collection.find({"patrao_id": patrao_id}))
    
    def count(self, query: dict = None) -> int:
        """Count users matching query."""
        return self.collection.count_documents(query or {})
    
    def get_all(self) -> List[dict]:
        """Get all users."""
        return list(self.collection.find())
    
    def get_roots(self) -> List[dict]:
        """Get users without patrão (root nodes of the tree)."""
        return list(self.collection.find({"patrao_id": None}))
    
    def _build_full_tree(self) -> Tuple[dict, List[dict], int]:
        """
        Build complete tree structure and return lookup dict.
        Uses cache if available and not expired.
        Returns: (users_by_id, roots, total)
        """
        global _tree_cache
        
        now = time.time()
        if _tree_cache["data"] and (now - _tree_cache["timestamp"]) < _tree_cache["ttl"]:
            return _tree_cache["data"]
        
        # Fetch all users
        all_users = list(self.collection.find())
        total = len(all_users)
        
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
        
        # Sort all children by start_year
        def sort_children(node):
            node["children"].sort(key=lambda x: x.get("start_year") or 0)
            for child in node["children"]:
                sort_children(child)
        
        roots.sort(key=lambda x: x.get("start_year") or 0)
        for root in roots:
            sort_children(root)
        
        # Cache the result
        _tree_cache["data"] = (users_by_id, roots, total)
        _tree_cache["timestamp"] = now
        
        return users_by_id, roots, total
    
    def _apply_depth_limit(self, node: dict, current_depth: int, max_depth: int) -> dict:
        """Create a copy of node with depth-limited children."""
        result = {k: v for k, v in node.items() if k != "children"}
        
        if current_depth >= max_depth:
            result["children"] = []
            result["has_more_children"] = len(node.get("children", [])) > 0
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
        
        Returns:
            Tuple of (root_nodes_with_children, total_count)
            - If root_id specified: returns subtree starting from that user
            - total_count: number of nodes in returned tree
        """
        users_by_id, roots, total = self._build_full_tree()
        
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
        
        result_count = count_nodes(roots) if root_id else total
        
        return roots, result_count
    
    def invalidate_tree_cache(self):
        """Invalidate the tree cache (call after user modifications)."""
        global _tree_cache
        _tree_cache["data"] = None
        _tree_cache["timestamp"] = 0
    
    def create(self, *, obj_in: UserCreate) -> dict:
        """Create new user."""
        self.invalidate_tree_cache()
        
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
        self.invalidate_tree_cache()
        
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
        self.invalidate_tree_cache()
        
        result = self.collection.delete_one({"_id": id})
        return result.deleted_count > 0
    
    def exists(self, id: int) -> bool:
        """Check if user exists."""
        return self.collection.count_documents({"_id": id}, limit=1) > 0


# Singleton instance
user = CRUDUser()
