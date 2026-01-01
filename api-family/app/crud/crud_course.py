"""
CRUD operations for Course collection.
Uses atomic counter for ID generation to avoid race conditions.
"""

from typing import Optional, List
from pymongo.collection import ReturnDocument
from pymongo.errors import DuplicateKeyError

from app.db.db import Course as CourseCollection, Counter
from app.schemas.course import CourseCreate, CourseUpdate


class CRUDCourse:
    """CRUD operations for Course collection."""
    
    def __init__(self):
        self.collection = CourseCollection
    
    def get(self, id: int) -> Optional[dict]:
        """Get course by ID."""
        return self.collection.find_one({"_id": id})
    
    def get_by_short(self, short: str) -> Optional[dict]:
        """Get course by short code."""
        return self.collection.find_one({"short": short})
    
    def get_multi(
        self, 
        *, 
        skip: int = 0, 
        limit: int = 100,
        degree: Optional[str] = None,
        show_only: bool = False
    ) -> List[dict]:
        """Get multiple courses with optional filters."""
        query = {}
        
        if degree:
            query["degree"] = degree
        
        if show_only:
            query["show"] = True
        
        # Use aggregation for sorting
        pipeline = [
            {"$match": query},
            {"$sort": {"degree": 1, "short": 1}},
            {"$skip": skip},
            {"$limit": limit}
        ]
        
        return list(self.collection.aggregate(pipeline))
    
    def count(self, query: dict = None) -> int:
        """Count courses matching query."""
        return self.collection.count_documents(query or {})
    
    def _get_next_id(self) -> int:
        """Get next ID using atomic counter (thread-safe)."""
        result = Counter.find_one_and_update(
            {"_id": "course_id"},
            {"$inc": {"seq": 1}},
            upsert=True,
            return_document=ReturnDocument.AFTER
        )
        return result["seq"]
    
    def create(self, *, obj_in: CourseCreate) -> dict:
        """
        Create new course.
        
        Returns: Created course document
        Raises: DuplicateKeyError if short code already exists
        """
        doc = obj_in.dict()
        doc["_id"] = self._get_next_id()
        
        # Convert enum to string for MongoDB
        if hasattr(doc.get("degree"), "value"):
            doc["degree"] = doc["degree"].value
        
        self.collection.insert_one(doc)
        return self.get(doc["_id"])
    
    def update(self, *, id: int, obj_in: CourseUpdate) -> Optional[dict]:
        """
        Update course by ID.
        
        Returns: Updated course or None if not found
        Raises: DuplicateKeyError if new short code already exists
        """
        update_data = obj_in.dict(exclude_unset=True)
        
        if not update_data:
            return self.get(id)
        
        # Convert enum to string for MongoDB
        if "degree" in update_data and hasattr(update_data["degree"], "value"):
            update_data["degree"] = update_data["degree"].value
        
        result = self.collection.find_one_and_update(
            {"_id": id},
            {"$set": update_data},
            return_document=ReturnDocument.AFTER
        )
        return result
    
    def delete(self, *, id: int) -> bool:
        """Delete course by ID."""
        result = self.collection.delete_one({"_id": id})
        return result.deleted_count > 0
    
    def exists(self, id: int) -> bool:
        """Check if course exists."""
        return self.collection.count_documents({"_id": id}, limit=1) > 0
    
    def short_exists(self, short: str, exclude_id: Optional[int] = None) -> bool:
        """Check if short code exists (optionally excluding a specific course)."""
        query = {"short": short}
        if exclude_id is not None:
            query["_id"] = {"$ne": exclude_id}
        return self.collection.count_documents(query, limit=1) > 0


# Singleton instance
course = CRUDCourse()
