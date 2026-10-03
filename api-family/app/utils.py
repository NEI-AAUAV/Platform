
def to_camel_case(alias: str):
    alias = alias.split('_')
    return ''.join([alias[0], *(w.capitalize() for w in alias[1:])])
