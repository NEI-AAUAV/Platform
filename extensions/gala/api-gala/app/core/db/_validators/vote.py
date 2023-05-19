_unique_persons = {
    "$expr": {
        "$eq": [
            {"$size": "$votes.uid"},
            {"$size": {"$setUnion": "$votes.uid"}},
        ]
    }
}

_option_within_range = {
    "$and": [
        {"$gte": ["$$this.option", 0]},
        {"$lt": ["$$this.option", {"$size": "$options"}]},
    ]
}

_option_exists = {
    "$expr": {
        "$reduce": {
            "input": "$votes",
            "initialValue": True,
            "in": {
                "$cond": {
                    "if": _option_within_range,
                    "then": "$$value",
                    "else": False,
                }
            },
        },
    }
}

vote_validator = {
    "$and": [_unique_persons, _option_exists],
}
