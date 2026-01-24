"""
Import JSON files from app/db/ directory to MongoDB.
This is a one-time migration script for importing legacy data.

Usage:
    python api-family/import_db_json.py
"""
import json
import os
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

def import_users():
    """Import users from users.json or users_seed.json."""
    db_dir = Path(__file__).parent / "app" / "db"
    
    # Try users.json first, fallback to users_seed.json
    users_path = db_dir / "users.json"
    if not users_path.exists():
        users_path = db_dir / "users_seed.json"
    
    if not users_path.exists():
        print(f"Users file not found in {db_dir}")
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

def import_user_roles():
    """Import user roles from user_roles.json or user_roles_seed.json."""
    db_dir = Path(__file__).parent / "app" / "db"
    
    # Try user_roles.json first, fallback to user_roles_seed.json
    roles_path = db_dir / "user_roles.json"
    if not roles_path.exists():
        roles_path = db_dir / "user_roles_seed.json"
    
    if not roles_path.exists():
        print(f"User roles file not found in {db_dir}")
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

def import_courses():
    """Import courses from courses.json."""
    db_dir = Path(__file__).parent / "app" / "db"
    courses_path = db_dir / "courses.json"
    
    if not courses_path.exists():
        print(f"Courses file not found in {db_dir}")
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

def import_counters():
    """Import counters from counters.json."""
    db_dir = Path(__file__).parent / "app" / "db"
    counters_path = db_dir / "counters.json"
    
    if not counters_path.exists():
        print(f"Counters file not found in {db_dir}")
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

def import_roles():
    """Import roles from roles.json."""
    db_dir = Path(__file__).parent / "app" / "db"
    roles_path = db_dir / "roles.json"
    
    if not roles_path.exists():
        print(f"Roles file not found in {db_dir}")
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
    print("Starting import from app/db/ JSON files...")
    print(f"Connecting to: {settings.MONGO_URI}")
    print(f"Database: {settings.MONGO_DB}")
    print("-" * 50)
    
    import_roles()
    import_courses()
    import_counters()
    import_users()
    import_user_roles()
    
    print("-" * 50)
    print("Import completed!")

