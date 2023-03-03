
def to_camel_case(alias: str):
    alias = alias.split('_')
    return ''.join([alias[0], *map(lambda w: w.capitalize(), alias[1:])])
