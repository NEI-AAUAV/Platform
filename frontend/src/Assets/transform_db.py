
import json

# Opening JSON file
f = open('db.json')

# returns JSON object as
# a dictionary
data = json.load(f)["users"]
f.close()

data2 = []

for row in data:
    if row["id"] == "000":
        continue

    was_probably_in_master = row["end_year"] and row["start_year"] + 2 < row["end_year"]
    was_in_organization = "organization" in row
    was_in_faina = "faina" in row

    matriculations = [{
        "course": "TSI" if row["start_year"] <= 14 else "LEI",
        "start_year": row["start_year"],
        "end_year": row["end_year"] and (row["start_year"] + 2 if was_probably_in_master else row["end_year"]),
    }]

    if was_probably_in_master:
        matriculations.append({
            "course": "MEI?",
            "start_year": row["start_year"] + 3,
            "end_year": row["end_year"],
        })

    insignias = []
    if was_in_organization:
        insignias = row["organizations"]

    faina = None
    if was_in_faina:
        faina = {
            "eqv_years": 0,
            "names": row["faina"],
            "baptism_name": None
        }

    user = {
        "id": row["id"],
        "name": row["name"],
        "email": None,
        "nmec": row["nmec"],
        "sex": row["sex"],
        "image": row["image"],

        "parent": row["parent"],

        "matriculations": matriculations,
        "insignias": insignias,
        "faina": faina
    }

    data2.append(user)


f = open('db2.json', 'w')
f.write(json.dumps(data2))
f.close()