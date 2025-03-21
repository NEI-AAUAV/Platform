# The number of confirmed persons
num_confirmed_companions = {
    "$reduce": {
        "input": "$persons",
        "initialValue": 0,
        "in": {"$add": ["$$value", {"$size": "$$this.companions"}]},
    },
}

# The number of confirmed persons
num_confirmed_persons = {
    "$reduce": {
        "input": "$persons",
        "initialValue": 0,
        "in": {
            "$cond": {
                "if": "$$this.confirmed",
                "then": {"$add": [{"$size": "$$this.companions"}, "$$value", 1]},
                "else": "$$value",
            }
        },
    },
}

table_is_empty = {"$eq": [{"$size": "$persons"}, 0]}

confirmed_persons_array = {
    "$filter": {
        "input": "$persons",
        "as": "person",
        "cond": "$$person.confirmed",
    }
}
