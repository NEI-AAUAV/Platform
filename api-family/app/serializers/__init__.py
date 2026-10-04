
def serialize_dict(b) -> dict:
    return {**{i: str(b[i]) for i in b if i == '_id'},
            **{i: b[i] for i in b if i != '_id'}}


def serialize_list(a) -> list:
    return [serialize_dict(b) for b in a]
