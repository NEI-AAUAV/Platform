import json
from pathlib import Path
from pymongo import MongoClient

# Configuration
MONGO_URI = "mongodb://mongo:mongo@db_mongo:27017/family?authSource=admin"
MONGO_DB = "family"

# Connect to MongoDB
try:
    client = MongoClient(MONGO_URI)
    db = client[MONGO_DB]
except Exception as e:
    print(f"FAILED TO CONNECT: {e}")
    exit(1)

users_col = db.users
roles_col = db.roles
user_roles_col = db.user_roles
courses_col = db.courses

def load_json(path):
    print(f"Loading {path}...")
    try:
        with open(path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"FAILED TO LOAD {path}: {e}")
        return []

def migrate_roles():
    print("Migrating roles...")
    # Adjust path relative to where script will be run (Platform root)
    roles_path = Path("roles.json")
    if not roles_path.exists():
        print(f"Roles file not found at {roles_path}")
        return {}

    roles = load_json(roles_path)
    if not roles: return {}

    role_map = {}
    # ... rest of function ... we need to insert try/except block widely if needed
    try:
        for role in roles:
            # ... unchanged logic ...
            old_id = role["_id"]
            super_roles = role.get("super_roles", "")
            
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
            
            doc = {k: v for k, v in doc.items() if v is not None}
            roles_col.replace_one({"_id": new_id}, doc, upsert=True)
        
        print(f"  Migrated {len(roles)} roles")
        return role_map
    except Exception as e:
        print(f"ERROR in migrate_roles: {e}")
        return {}

def get_role_id_by_name(role_name, org_name, roles_in_db):
    org_map = {
        "CF": ".1.5.",
        "CS": ".1.6.",
        "ST": ".1.7.",
        "NEI": ".2.",
        "AETTUA": ".3.",
        "AAUAv": ".4."
    }
    
    org_prefix = org_map.get(org_name, "")
    
    if not role_name:
        return org_prefix
    
    for role_id, role_data in roles_in_db.items():
        if role_data.get("name") == role_name and role_id.startswith(org_prefix):
            return role_id
    
    return org_prefix

def migrate_users():
    print("Migrating users...")
    db_json_path = Path("db.json")
    
    if not db_json_path.exists():
         print(f"DB file not found at {db_json_path}")
         return

    data = load_json(db_json_path)
    users = data.get("users", [])
    
    roles_in_db = {r["_id"]: r for r in roles_col.find()}
    
    user_count = 0
    role_count = 0
    
    for user in users:
        if user.get("id") == 0:
            continue
        
        faina_data = user.get("faina", [])
        faina_name = None
        if faina_data and len(faina_data) > 0:
            faina_name = faina_data[0].get("name") if isinstance(faina_data[0], dict) else None
        if not faina_name:
            faina_name = user["name"].split()[-1]
        
        user_doc = {
            "_id": user["id"],
            "nmec": user.get("nmec"),
            "name": user["name"],
            "faina_name": faina_name,
            "sex": user.get("sex"),
            "course_id": None,
            "patrao_id": user.get("parent") if user.get("parent") != 0 else None,
            "start_year": user.get("start_year"),
            "end_year": user.get("end_year")
        }
        
        users_col.replace_one({"_id": user["id"]}, user_doc, upsert=True)
        user_count += 1
        
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
                "role_name": role_name,
                "org_name": org_name,
                "year": year,
                "end_year": year, 
            }
            
            # Upsert to ensure fields are added
            user_roles_col.replace_one({
                "user_id": user["id"],
                "role_id": role_id,
                "year": year
            }, user_role_doc, upsert=True)
            role_count += 1

    print(f"Migrated {user_count} users, {role_count} roles.")

def create_indexes():
    print("Creating indexes...")
    users_col.create_index("nmec", unique=True, partialFilterExpression={"nmec": {"$type": "int"}})
    users_col.create_index("patrao_id")
    users_col.create_index("start_year")
    user_roles_col.create_index("user_id")
    user_roles_col.create_index("role_id")
    user_roles_col.create_index([("user_id", 1), ("role_id", 1), ("year", 1)], unique=True)
    print("Done")

if __name__ == "__main__":
    migrate_roles()
    migrate_users()
    create_indexes()
