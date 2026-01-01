"""
MongoDB database connection and collection setup.
Optimized for performance with proper indexing and connection pooling.
"""

from typing import Generator
import logging

from pymongo import MongoClient, ASCENDING
from pymongo.errors import OperationFailure

from app.core.config import settings


logger = logging.getLogger(__name__)


# Connection with optimized pool settings
client = MongoClient(
    settings.MONGO_URI,
    # Connection pool settings
    maxPoolSize=50,           # Max connections in pool
    minPoolSize=10,           # Keep min connections ready
    maxIdleTimeMS=30000,      # Close idle connections after 30s
    waitQueueTimeoutMS=5000,  # Timeout waiting for connection
    # Performance settings
    retryWrites=True,         # Retry failed writes
    retryReads=True,          # Retry failed reads
    w="majority",             # Write concern for durability
    readPreference="primaryPreferred",  # Read from primary, fallback to secondary
    # Compression
    compressors=["zstd", "snappy", "zlib"],  # Compress network traffic
)

print('Connected to MongoDB...')

db = client[settings.MONGO_DB]

# Collections
Counter = db.counters
User = db.users
Patch = db.patches
Course = db.courses
Organization = db.organizations

# Normalized collections
Role = db.roles
UserRole = db.user_roles


def create_indexes():
    """Create all indexes for optimal query performance."""
    try:
        # ========== User Indexes ==========
        # Primary lookups
        User.create_index("ref_id", unique=True, sparse=True)
        User.create_index("nmec", sparse=True)
        
        # Tree building (patrao_id + start_year for sorted children)
        User.create_index([("patrao_id", ASCENDING), ("start_year", ASCENDING)])
        User.create_index("patrao_id")  # For get_children queries
        
        # Filtering
        User.create_index("start_year")
        User.create_index("course_id")
        
        # Legacy indexes
        User.create_index("academic.lastMatriculationYear", sparse=True)
        User.create_index("faina.firstTrajadoYear", sparse=True)
        
        # ========== UserRole Indexes ==========
        # Unique constraint
        UserRole.create_index(
            [("user_id", ASCENDING), ("role_id", ASCENDING), ("year", ASCENDING)],
            unique=True
        )
        # Individual lookups
        UserRole.create_index("user_id")
        UserRole.create_index("role_id")
        UserRole.create_index("year")
        # Compound for filtered queries
        UserRole.create_index([("user_id", ASCENDING), ("year", ASCENDING)])
        UserRole.create_index([("role_id", ASCENDING), ("year", ASCENDING)])
        
        # ========== Role Indexes ==========
        Role.create_index("super_roles")  # For tree building
        Role.create_index("show")         # For filtering
        
        # ========== Course Indexes ==========
        Course.create_index("degree")     # For filtering
        Course.create_index("show")       # For filtering
        Course.create_index("short", unique=True)  # Unique short codes
        Course.create_index([("degree", ASCENDING), ("short", ASCENDING)])  # Compound for sorting
        
        # ========== Patch Indexes ==========
        Patch.create_index("patcherId")
        Patch.create_index("user_id", sparse=True)
        
        logger.info("All indexes created successfully")
        
    except OperationFailure as e:
        logger.warning(f"Some indexes may already exist or failed: {e}")


# Create indexes on startup
create_indexes()


def get_db() -> Generator:
    """Get database connection (for dependency injection if needed)."""
    try:
        yield db
    finally:
        pass  # Connection pooling handles cleanup


def close_connection():
    """Close MongoDB connection gracefully."""
    client.close()
    logger.info("MongoDB connection closed")
