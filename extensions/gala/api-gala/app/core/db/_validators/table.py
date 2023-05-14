import app.queries.table as queries

# The number of confirmed persons is less than the seats available
_confirmed_persons_lte_seats = {
    "$expr": {
        "$lte": [
            queries.num_confirmed_persons,
            "$seats",
        ]
    }
}

# The number of companions is less than the number of seats
_companions_lt_seats = {
    "$expr": {
        "$reduce": {
            "input": "$persons",
            "initialValue": True,
            "in": {
                "$cond": {
                    "if": {"lt": [{"$size": "$$this.companions"}, "$seats"]},
                    "then": "$$value",
                    "else": False,
                }
            },
        },
    }
}

# Checks that there are no duplicate persons by id
#
# source: https://jira.mongodb.org/browse/SERVER-1068
_unique_persons = {
    "$expr": {
        "$eq": [
            {"$size": "$persons.id"},
            {"$size": {"$setUnion": "$persons.id"}},
        ]
    }
}


# Selects the person that is the head of the table
_select_head_person = {
    "$first": {
        "$filter": {
            "input": "$persons",
            "as": "person",
            "cond": {"$eq": ["$$person.id", "$head"]},
        }
    }
}

# Checks if the head person is confirmed
_head_is_confirmed = {
    "$expr": {
        "$getField": {
            "input": _select_head_person,
            "field": "confirmed",
        }
    }
}

# Checks if the head is none
_head_is_none = {"$expr": {"$eq": ["$head", None]}}

table_validator = {
    "$and": [
        _companions_lt_seats,
        _confirmed_persons_lte_seats,
        {"$expr": {"$eq": [{"$eq": ["$head", None]}, queries.table_is_empty]}},
        {
            "$or": [
                _head_is_none,
                _head_is_confirmed,
            ]
        },
        _unique_persons,
    ],
}
