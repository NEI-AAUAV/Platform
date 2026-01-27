"""
Import JSON files to MongoDB.
This is a one-time migration script for importing legacy data.

Usage:
    python api-family/import_db_json.py [source_directory]

If source_directory is not provided, defaults to api-family/app/db/
"""
import json
import os
import sys
from pathlib import Path
from pymongo import MongoClient
from app.core.config import settings

def load_json(path):
    """Load JSON file."""
    print(f"Loading {path}...")
    try:
        with open(path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"FAILED TO LOAD {path}: {e}")
        return None

def get_source_dir():
    """Get source directory from command line or use default."""
    if len(sys.argv) > 1:
        source_dir = Path(sys.argv[1])
        if not source_dir.exists():
            print(f"ERROR: Source directory does not exist: {source_dir}")
            sys.exit(1)
        return source_dir
    return Path(__file__).parent / "app" / "db"

def import_users(source_dir):
    """Import users from users_seed.json."""
    users_path = source_dir / "users_seed.json"
    
    if not users_path.exists():
        print(f"ERROR: users_seed.json not found in {source_dir}")
        return 0
    
    users = load_json(users_path)
    if not users:
        return 0
    
    client = MongoClient(settings.MONGO_URI)
    db = client[settings.MONGO_DB]
    users_col = db.users
    
    count = 0
    for user in users:
        try:
            users_col.replace_one({"_id": user["_id"]}, user, upsert=True)
            count += 1
        except Exception as e:
            print(f"Error importing user {user.get('_id')}: {e}")
    
    print(f"Imported {count} users")
    client.close()
    return count

def import_user_roles(source_dir):
    """Import user roles from user_roles_seed.json."""
    roles_path = source_dir / "user_roles_seed.json"
    
    if not roles_path.exists():
        print(f"ERROR: user_roles_seed.json not found in {source_dir}")
        return 0
    
    user_roles = load_json(roles_path)
    if not user_roles:
        return 0
    
    client = MongoClient(settings.MONGO_URI)
    db = client[settings.MONGO_DB]
    user_roles_col = db.user_roles
    
    count = 0
    for user_role in user_roles:
        try:
            # Use unique constraint fields for upsert
            filter_doc = {
                "user_id": user_role.get("user_id"),
                "role_id": user_role.get("role_id"),
                "year": user_role.get("year")
            }
            user_roles_col.replace_one(filter_doc, user_role, upsert=True)
            count += 1
        except Exception as e:
            print(f"Error importing user_role {user_role.get('user_id')}: {e}")
    
    print(f"Imported {count} user roles")
    client.close()
    return count

def import_courses(source_dir):
    """Import courses from courses.json."""
    courses_path = source_dir / "courses.json"
    
    if not courses_path.exists():
        print(f"Courses file not found in {source_dir}")
        return 0
    
    courses = load_json(courses_path)
    if not courses:
        return 0
    
    client = MongoClient(settings.MONGO_URI)
    db = client[settings.MONGO_DB]
    courses_col = db.courses
    
    count = 0
    for course in courses:
        try:
            courses_col.replace_one({"_id": course["_id"]}, course, upsert=True)
            count += 1
        except Exception as e:
            print(f"Error importing course {course.get('_id')}: {e}")
    
    print(f"Imported {count} courses")
    client.close()
    return count

def import_counters(source_dir):
    """Import counters from counters.json."""
    counters_path = source_dir / "counters.json"
    
    if not counters_path.exists():
        print(f"Counters file not found in {source_dir}")
        return 0
    
    counters = load_json(counters_path)
    if not counters:
        return 0
    
    client = MongoClient(settings.MONGO_URI)
    db = client[settings.MONGO_DB]
    counters_col = db.counters
    
    count = 0
    for counter in counters:
        try:
            counters_col.replace_one({"_id": counter["_id"]}, counter, upsert=True)
            count += 1
        except Exception as e:
            print(f"Error importing counter {counter.get('_id')}: {e}")
    
    print(f"Imported {count} counters")
    client.close()
    return count

def import_roles(source_dir):
    """Import roles from roles.json."""
    roles_path = source_dir / "roles.json"
    
    if not roles_path.exists():
        print(f"ERROR: roles.json not found in {source_dir}")
        return 0
    
    roles = load_json(roles_path)
    if not roles:
        return 0
    
    client = MongoClient(settings.MONGO_URI)
    db = client[settings.MONGO_DB]
    roles_col = db.roles
    
    count = 0
    for role in roles:
        try:
            roles_col.replace_one({"_id": role["_id"]}, role, upsert=True)
            count += 1
        except Exception as e:
            print(f"Error importing role {role.get('_id')}: {e}")
    
    print(f"Imported {count} roles")
    client.close()
    return count

if __name__ == "__main__":
    source_dir = get_source_dir()
    
    print("=" * 60)
    print("MongoDB JSON Import Script")
    print("=" * 60)
    print(f"Source directory: {source_dir}")
    print(f"MongoDB URI: {settings.MONGO_URI}")
    print(f"Database: {settings.MONGO_DB}")
    print("-" * 60)
    
    # Import in order: roles, courses, counters, users, user_roles
    # (roles and courses should exist before user_roles)
    import_roles(source_dir)
    import_courses(source_dir)
    import_counters(source_dir)
    import_users(source_dir)
    import_user_roles(source_dir)
    
    print("-" * 70)
    print("Import completed!")
    print("=" * 70)

