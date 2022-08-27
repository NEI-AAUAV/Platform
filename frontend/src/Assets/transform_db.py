
import json

# Opening JSON file
f = open('db.json')

# returns JSON object as
# a dictionary
data = json.load(f)["users"]
f.close()

data2 = "[\n\t"

for i, row in enumerate(data):
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

    # beautify output
    user_str = json.dumps(user, ensure_ascii=False) \
        .replace('"id"', '\n\t\t"id"') \
            .replace('"matriculations"', '\n\t\t"matriculations"') \
                .replace('"insignias"', '\n\t\t"insignias"') \
                    .replace('"faina"', '\n\t\t"faina"')

    data2 += user_str[:-1] + '\n\t}'

    if i < len(data) - 1:
        if data[i]["start_year"] == data[i + 1]["start_year"]:
            data2 += ', '
        else:
            data2 += ',\n\n\n\t'

data2 += '\n]'


f = open('db2.json', 'w')
f.write(data2)
f.close()