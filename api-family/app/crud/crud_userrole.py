"""
CRUD operations for UserRole collection.
"""

from typing import Optional, List
from bson import ObjectId
from pymongo.collection import ReturnDocument

from app.db.db import UserRole as UserRoleCollection, User as UserCollection, Role as RoleCollection
from app.schemas.userrole import UserRoleCreate, UserRoleUpdate


class CRUDUserRole:
    """CRUD operations for UserRole collection."""
    
    def __init__(self):
        self.collection = UserRoleCollection
    
    def get(self, id: str) -> Optional[dict]:
        """Get user-role by ID."""
        try:
            return self.collection.find_one({"_id": ObjectId(id)})
        except:
            return None
    
    def get_by_user(self, user_id: int) -> List[dict]:
        """Get all roles for a user."""
        return list(self.collection.find({"user_id": user_id}))
    
    def get_by_role(self, role_id: str) -> List[dict]:
        """Get all users with a specific role."""
        return list(self.collection.find({"role_id": role_id}))
    
    def get_by_year(self, year: int) -> List[dict]:
        """Get all user-roles for a specific year."""
        return list(self.collection.find({"year": year}))
    
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
        query = {}
        
        if user_id is not None:
            query["user_id"] = user_id
        if role_id is not None:
            query["role_id"] = role_id
        if year is not None:
            query["year"] = year
        
        cursor = self.collection.find(query).skip(skip).limit(limit)
        return list(cursor)
    
    def get_with_details(self, user_roles: List[dict]) -> List[dict]:
        """Enrich user-roles with user and role names."""
        # Get all unique user_ids and role_ids
        user_ids = list(set(ur["user_id"] for ur in user_roles))
        role_ids = list(set(ur["role_id"] for ur in user_roles))
        
        # Fetch users and roles
        users = {u["_id"]: u for u in UserCollection.find({"_id": {"$in": user_ids}})}
        roles = {r["_id"]: r for r in RoleCollection.find({"_id": {"$in": role_ids}})}
        
        # Enrich
        result = []
        for ur in user_roles:
            user = users.get(ur["user_id"], {})
            role = roles.get(ur["role_id"], {})
            result.append({
                "_id": str(ur["_id"]),
                "user_id": ur["user_id"],
                "role_id": ur["role_id"],
                "year": ur["year"],
                "user_name": user.get("name"),
                "role_name": role.get("name"),
                "role_short": role.get("short")
            })
        return result
    
    def count(self, query: dict = None) -> int:
        """Count user-roles matching query."""
        return self.collection.count_documents(query or {})
    
    def create(self, *, obj_in: UserRoleCreate) -> dict:
        """Create new user-role association."""
        doc = obj_in.dict()
        result = self.collection.insert_one(doc)
        return self.get(str(result.inserted_id))
    
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
            return result
        except:
            return None
    
    def delete(self, *, id: str) -> bool:
        """Delete user-role by ID."""
        try:
            result = self.collection.delete_one({"_id": ObjectId(id)})
            return result.deleted_count > 0
        except:
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
