
def serializeDict(b) -> dict:
    return {**{i: str(b[i]) for i in b if i == '_id'},
            **{i: b[i] for i in b if i != '_id'}}


def serializeList(a) -> list:
    return [serializeDict(b) for b in a]
