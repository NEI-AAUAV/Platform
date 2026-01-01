"""
CRUD operations for UserRole collection.
"""

import logging
from typing import Optional, List, Dict, Any
from bson import ObjectId
from bson.errors import InvalidId
from pymongo.collection import ReturnDocument

from app.db.db import UserRole as UserRoleCollection, User as UserCollection, Role as RoleCollection
from app.schemas.userrole import UserRoleCreate, UserRoleUpdate


logger = logging.getLogger(__name__)


class CRUDUserRole:
    """CRUD operations for UserRole collection."""
    
    def __init__(self):
        self.collection = UserRoleCollection
    
    @staticmethod
    def _build_query(
        user_id: Optional[int] = None,
        role_id: Optional[str] = None,
        year: Optional[int] = None
    ) -> Dict[str, Any]:
        """Build MongoDB query from optional filters. Reusable for get_multi and count."""
        query = {}
        if user_id is not None:
            query["user_id"] = user_id
        if role_id is not None:
            query["role_id"] = role_id
        if year is not None:
            query["year"] = year
        return query
    
    @staticmethod
    def _serialize(doc: dict) -> dict:
        """Convert ObjectId to string for API response."""
        if doc and "_id" in doc:
            doc["_id"] = str(doc["_id"])
        return doc
    
    def get(self, id: str) -> Optional[dict]:
        """Get user-role by ID."""
        try:
            doc = self.collection.find_one({"_id": ObjectId(id)})
            return self._serialize(doc) if doc else None
        except InvalidId:
            return None
    
    def get_by_user(self, user_id: int) -> List[dict]:
        """Get all roles for a user."""
        return [self._serialize(doc) for doc in self.collection.find({"user_id": user_id})]
    
    def get_by_role(self, role_id: str) -> List[dict]:
        """Get all users with a specific role."""
        return [self._serialize(doc) for doc in self.collection.find({"role_id": role_id})]
    
    def get_by_year(self, year: int) -> List[dict]:
        """Get all user-roles for a specific year."""
        return [self._serialize(doc) for doc in self.collection.find({"year": year})]
    
    def get_multi(
        self, 
        *, 
        skip: int = 0, 
        limit: int = 100,
        user_id: Optional[int] = None,
        role_id: Optional[str] = None,
        year: Optional[int] = None
    ) -> List[dict]:
        """Get multiple user-roles with optional filters."""
        query = self._build_query(user_id=user_id, role_id=role_id, year=year)
        cursor = self.collection.find(query).skip(skip).limit(limit)
        return [self._serialize(doc) for doc in cursor]
    
    def get_with_details(
        self, 
        user_roles: Optional[List[dict]] = None,
        user_id: Optional[int] = None,
        role_id: Optional[str] = None,
        year: Optional[int] = None,
        skip: int = 0,
        limit: int = 100
    ) -> tuple[List[dict], int]:
        """
        Enrich user-roles with user and role names using MongoDB aggregation.
        Returns tuple of (enriched_items, total_count).
        """
        query = self._build_query(user_id=user_id, role_id=role_id, year=year)
        
        # Get total count first
        total = self.collection.count_documents(query)
        
        if total == 0:
            return [], 0
        
        # Aggregation pipeline with $lookup for joins
        pipeline = [
            {"$match": query},
            {"$skip": skip},
            {"$limit": limit},
            # Join with users collection
            {"$lookup": {
                "from": "users",
                "localField": "user_id",
                "foreignField": "_id",
                "as": "user"
            }},
            # Join with roles collection
            {"$lookup": {
                "from": "roles",
                "localField": "role_id",
                "foreignField": "_id",
                "as": "role"
            }},
            # Unwind arrays (convert from array to single doc)
            {"$unwind": {"path": "$user", "preserveNullAndEmptyArrays": True}},
            {"$unwind": {"path": "$role", "preserveNullAndEmptyArrays": True}},
            # Project final shape
            {"$project": {
                "_id": {"$toString": "$_id"},
                "user_id": 1,
                "role_id": 1,
                "year": 1,
                "user_name": "$user.name",
                "role_name": "$role.name",
                "role_short": "$role.short"
            }}
        ]
        
        result = list(self.collection.aggregate(pipeline))
        return result, total
    
    def count(
        self, 
        user_id: Optional[int] = None,
        role_id: Optional[str] = None,
        year: Optional[int] = None
    ) -> int:
        """Count user-roles matching filters."""
        query = self._build_query(user_id=user_id, role_id=role_id, year=year)
        return self.collection.count_documents(query)
    
    def create(self, *, obj_in: UserRoleCreate) -> Optional[dict]:
        """Create new user-role association. Returns None if creation fails."""
        doc = obj_in.dict()
        result = self.collection.insert_one(doc)
        created = self.get(str(result.inserted_id))
        return created
    
    def update(self, *, id: str, obj_in: UserRoleUpdate) -> Optional[dict]:
        """Update user-role by ID."""
        update_data = obj_in.dict(exclude_unset=True)
        
        if not update_data:
            return self.get(id)
        
        try:
            result = self.collection.find_one_and_update(
                {"_id": ObjectId(id)},
                {"$set": update_data},
                return_document=ReturnDocument.AFTER
            )
            return self._serialize(result) if result else None
        except InvalidId:
            return None
    
    def delete(self, *, id: str) -> bool:
        """Delete user-role by ID."""
        try:
            result = self.collection.delete_one({"_id": ObjectId(id)})
            return result.deleted_count > 0
        except InvalidId:
            return False
    
    def delete_by_user(self, user_id: int) -> int:
        """Delete all roles for a user."""
        result = self.collection.delete_many({"user_id": user_id})
        return result.deleted_count
    
    def exists(self, user_id: int, role_id: str, year: int) -> bool:
        """Check if a user-role association exists."""
        return self.collection.count_documents({
            "user_id": user_id,
            "role_id": role_id,
            "year": year
        }, limit=1) > 0


# Singleton instance
user_role = CRUDUserRole()
