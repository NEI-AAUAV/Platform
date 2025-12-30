"""
CRUD operations for Role collection.
"""

from typing import Optional, List

from app.db.db import Role as RoleCollection
from app.schemas.role_simple import RoleCreate, RoleUpdate


class CRUDRole:
    """CRUD operations for Role collection."""
    
    def __init__(self):
        self.collection = RoleCollection
    
    def get(self, id: str) -> Optional[dict]:
        """Get role by ID (path format like '.1.5.')."""
        return self.collection.find_one({"_id": id})
    
    def get_multi(
        self, 
        *, 
        skip: int = 0, 
        limit: int = 100,
        show_only: bool = False,
        parent: Optional[str] = None
    ) -> List[dict]:
        """Get multiple roles with optional filters."""
        query = {}
        
        if show_only:
            query["show"] = True
        
        if parent is not None:
            query["super_roles"] = parent
        
        cursor = self.collection.find(query).skip(skip).limit(limit)
        return list(cursor)
    
    def get_children(self, parent_id: str) -> List[dict]:
        """Get all child roles of a parent role."""
        return list(self.collection.find({"super_roles": parent_id}))
    
    def get_tree(self) -> List[dict]:
        """Get all roles organized as a tree structure."""
        all_roles = list(self.collection.find())
        
        # Build tree
        root_roles = [r for r in all_roles if r["super_roles"] == ""]
        
        def add_children(role):
            role_id = role["_id"]
            children = [r for r in all_roles if r["super_roles"] == role_id]
            if children:
                role["children"] = [add_children(c) for c in children]
            return role
        
        return [add_children(r) for r in root_roles]
    
    def count(self, query: dict = None) -> int:
        """Count roles matching query."""
        return self.collection.count_documents(query or {})
    
    def create(self, *, obj_in: RoleCreate) -> dict:
        """Create new role."""
        # Generate next ID based on parent
        if obj_in.super_roles:
            # Find max ID under this parent
            siblings = list(self.collection.find({"super_roles": obj_in.super_roles}))
            if siblings:
                max_num = max(int(s["_id"].rstrip('.').split('.')[-1]) for s in siblings)
                next_num = max_num + 1
            else:
                next_num = 1
            new_id = f"{obj_in.super_roles}{next_num}."
        else:
            # Root level
            roots = list(self.collection.find({"super_roles": ""}))
            if roots:
                max_num = max(int(r["_id"].strip('.')) for r in roots)
                next_num = max_num + 1
            else:
                next_num = 1
            new_id = f".{next_num}."
        
        doc = obj_in.dict()
        doc["_id"] = new_id
        
        self.collection.insert_one(doc)
        return self.get(new_id)
    
    def update(self, *, id: str, obj_in: RoleUpdate) -> Optional[dict]:
        """Update role by ID."""
        update_data = obj_in.dict(exclude_unset=True)
        
        if not update_data:
            return self.get(id)
        
        from pymongo.collection import ReturnDocument
        result = self.collection.find_one_and_update(
            {"_id": id},
            {"$set": update_data},
            return_document=ReturnDocument.AFTER
        )
        return result
    
    def delete(self, *, id: str) -> bool:
        """Delete role by ID."""
        result = self.collection.delete_one({"_id": id})
        return result.deleted_count > 0
    
    def exists(self, id: str) -> bool:
        """Check if role exists."""
        return self.collection.count_documents({"_id": id}, limit=1) > 0


# Singleton instance
role = CRUDRole()
