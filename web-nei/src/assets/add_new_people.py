import json

def read_json_file(file_path):
    with open(file_path, 'r') as file:
        return json.load(file)

def write_json_file(file_path, data):
    with open(file_path, 'w') as file:
        json.dump(data, file, indent=4)

def transform_db_2():
    name_to_id = {}
    db = read_json_file('db.json')
    new_people = read_json_file('new_people.json')
    users = db['users']
    id_tracker = 0
    failed_inserts = {}
    for user in users:
        name_to_id[user['name']] = user['id']
    
    id_tracker = len(users)
    # print(id_tracker)
    for new_group in new_people:
        father_id = name_to_id[new_group['father']]
        for child in new_group['children']:
            child["id"] = id_tracker
            id_tracker += 1
            child["nmec"] = None
            child["parent"] = father_id
            child["end_year"] = None
            child["image"] = ""
            users.append(child)
            name_to_id[child['name']] = child['id']
    
    print(failed_inserts)
    write_json_file('new_db.json', db)
    

        
        

if __name__ == '__main__':
    transform_db_2()