
## Mongo schemas

### User

```json
{
    "id": "objectId",           // automatic generated ID
    "name": "string",
    "nickname": "string|null",
    "email": "string|null",
    "nmec": "int|null",              
    "sex": "string",
    "image": "string|null",
    "start_year": "int",        // matriculation year in LEI
    "end_year": "int|null",     // 
    "parent": "int|null",       // the ID of the 
    "organizations": "array",
    "faina": "array"
}
```

master

name:
baptism_name:

### Organizations

```json
{
    "year": "int",
    "name": "string",
    "role": "string"
}
```

### Faina

```json
{
    "year": "int",          // 
    "name": "string",       // Faina name
}
```


há pessoas q nao fizeram LEI
há pessoas q nao fizeram Faina
há pessoas q comecaram LEI com pelo menos 1 ano de faina feito
há organizacoes com mandatos de início e duração variáveis
há pessoas que têm nomes de faina diferentes noutros anos
