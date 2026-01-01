"""
CRUD operations for Course collection.
"""

from typing import Optional, List
from pymongo.collection import ReturnDocument

from app.db.db import Course as CourseCollection
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
    
    def create(self, *, obj_in: CourseCreate) -> dict:
        """Create new course."""
        # Get next ID
        max_doc = self.collection.find_one(sort=[("_id", -1)])
        next_id = (max_doc["_id"] + 1) if max_doc else 1
        
        doc = obj_in.dict()
        doc["_id"] = next_id
        
        self.collection.insert_one(doc)
        return self.get(next_id)
    
    def update(self, *, id: int, obj_in: CourseUpdate) -> Optional[dict]:
        """Update course by ID."""
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
        """Delete course by ID."""
        result = self.collection.delete_one({"_id": id})
        return result.deleted_count > 0
    
    def exists(self, id: int) -> bool:
        """Check if course exists."""
        return self.collection.count_documents({"_id": id}, limit=1) > 0


# Singleton instance
course = CRUDCourse()
