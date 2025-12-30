"""
CRUD operations for User collection.
"""

from typing import Optional, List, Any
from pymongo.collection import ReturnDocument

from app.db.db import User as UserCollection
from app.schemas.user_simple import UserCreate, UserUpdate, UserInDB


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
