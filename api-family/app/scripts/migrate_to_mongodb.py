"""
Migration Script: Transform static JSON to MongoDB new structure

Collections to populate:
1. users - Basic user info + faina data
2. roles - Role definitions (from roles.json)  
3. user_roles - User-Role associations

"""

import json
from pathlib import Path
from pymongo import MongoClient
from app.core.config import settings

# Connect to MongoDB
client = MongoClient(settings.MONGO_URI)
db = client[settings.MONGO_DB]

# Collections
users_col = db.users
roles_col = db.roles
user_roles_col = db.user_roles
courses_col = db.courses

def load_json(path: str):
    """Load JSON file"""
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)


def migrate_roles():
    """Migrate roles from roles.json"""
    print("Migrating roles...")
    roles_path = Path(__file__).parent.parent / "db" / "roles.json"
    roles = load_json(roles_path)
    
    # Transform _id from int to string path format
    role_map = {}
    
    for role in roles:
        old_id = role["_id"]
        super_roles = role.get("super_roles", "")
        
        # Generate new ID based on hierarchy
        # Root orgs: 1->".1.", 2->".2.", etc
        if super_roles == "":
            new_id = f".{old_id}."
        else:
            new_id = f"{super_roles}{old_id}."
        
        role_map[old_id] = new_id
        
        doc = {
            "_id": new_id,
            "name": role["name"],
            "short": role.get("short"),
            "female_name": role.get("female_name"),
            "super_roles": super_roles,
            "show": role.get("show", False)
        }
        
        # Remove None values
        doc = {k: v for k, v in doc.items() if v is not None}
        
        roles_col.replace_one({"_id": new_id}, doc, upsert=True)
    
    print(f"  Migrated {len(roles)} roles")
    return role_map


def get_role_id_by_name(role_name: str, org_name: str, roles_in_db: dict) -> str:
    """Find role_id by name and organization"""
    # Map organization short names to root IDs
    org_map = {
        "CF": ".1.5.",
        "CS": ".1.6.",
        "ST": ".1.7.",
        "NEI": ".2.",
        "AETTUA": ".3.",
        "AAUAv": ".4."
    }
    
    org_prefix = org_map.get(org_name, "")
    
    # If no specific role, return the org itself
    if not role_name:
        return org_prefix
    
    # Search for matching role in DB
    for role_id, role_data in roles_in_db.items():
        if role_data.get("name") == role_name and role_id.startswith(org_prefix):
            return role_id
    
    # Fallback: just return org prefix
    return org_prefix


def migrate_users():
    """Migrate users from web-nei db.json"""
    print("Migrating users...")
    
    # Load main data file
    platform_root = Path(__file__).parent.parent.parent.parent
    db_json_path = platform_root / "web-nei" / "src" / "assets" / "db.json"
    print(f"  Loading from: {db_json_path}")
    data = load_json(db_json_path)
    users = data.get("users", [])
    
    # Load roles from DB for lookup
    roles_in_db = {r["_id"]: r for r in roles_col.find()}
    
    user_count = 0
    role_count = 0
    
    for user in users:
        # Skip the root node (id=0)
        if user.get("id") == 0:
            continue
        
        # Get faina name from faina array if exists, otherwise use last name
        faina_data = user.get("faina", [])
        faina_name = None
        if faina_data and len(faina_data) > 0:
            # faina is array of {name, year} in original data
            faina_name = faina_data[0].get("name") if isinstance(faina_data[0], dict) else None
        if not faina_name:
            faina_name = user["name"].split()[-1]  # Use last name as fallback
        
        # Simplified user structure - only fields actually used
        user_doc = {
            "_id": user["id"],
            "nmec": user.get("nmec"),
            "name": user["name"],
            "faina_name": faina_name,
            "sex": user.get("sex"),
            "course_id": None,  # To be filled manually if needed (not used in current version - use for people of other course)
            "patrao_id": user.get("parent") if user.get("parent") != 0 else None,
            "start_year": user.get("start_year"),
            "end_year": user.get("end_year")
        }
        
        # Insert/update user
        users_col.replace_one({"_id": user["id"]}, user_doc, upsert=True)
        user_count += 1
        
        # Process organizations -> user_roles
        orgs = user.get("organizations", [])
        for org in orgs:
            year = org.get("year")
            org_name = org.get("name")
            role_name = org.get("role")
            
            if not org_name or year is None:
                continue
            
            role_id = get_role_id_by_name(role_name, org_name, roles_in_db)
            
            user_role_doc = {
                "user_id": user["id"],
                "role_id": role_id,
                "year": year,
                "end_year": year, 
            }
            
            # Check if already exists
            existing = user_roles_col.find_one({
                "user_id": user["id"],
                "role_id": role_id,
                "year": year
            })
            
            if not existing:
                user_roles_col.insert_one(user_role_doc)
                role_count += 1


def migrate_courses():
    """Migrate courses from courses.json"""
    courses_path = Path(__file__).parent.parent / "db" / "courses.json"
    
    if not courses_path.exists():
        print("  courses.json not found, skipping")
        return
    
    courses = load_json(courses_path)
    
    for course in courses:
        courses_col.replace_one({"_id": course["_id"]}, course, upsert=True)
    
    print(f"  Migrated {len(courses)} courses")


def create_indexes():
    """Create MongoDB indexes"""
    print("Creating indexes...")
    
    # Use partialFilterExpression to only index non-null nmec values
    users_col.create_index(
        "nmec", 
        unique=True, 
        partialFilterExpression={"nmec": {"$type": "int"}}
    )
    users_col.create_index("patrao_id")
    users_col.create_index("start_year")
    
    user_roles_col.create_index("user_id")
    user_roles_col.create_index("role_id")
    user_roles_col.create_index([("user_id", 1), ("role_id", 1), ("year", 1)], unique=True)
    
    print("  Done")


def main():
    migrate_roles()
    migrate_users()
    migrate_courses()
    create_indexes()

if __name__ == "__main__":
    main()
