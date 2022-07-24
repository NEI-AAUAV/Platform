
## Mongo schemas

Problems found on the schemas creation:
- there are people who did not do LEI, only Masters
- there are people who have not done faina
- there are people who started LEI/TSI with at least 1 year of faina done
- there are people who have different faina names during the years
- there are people who dropped out of LEI/TSI <span style="color:#ECB22E">**[still needs some thought]**</span>
- there are organizations with variable start and duration periods


### User

The most top level object with basic user information.

```jsonc
{
    "id": "objectId",           // automatic generated ID
    "name": "string",
    "nickname": "string|null",  // useful and only provided for people who are more easily recognized by their nickname
    "email": "string|null",
    "nmec": "int|null",  
    "sex": "string",            // gender: "M"ale or "F"emale
    "image": "string|null",     // profile image URL

    "parent": "int|null",       // patrão/patroa ID

    "matriculations": "array[Matriculation]",
    "insignias": "array[Insignia]",
    "faina": "Faina|null",      // null if did not do/complete the faina
}
```


### Matriculation

Only people with TSI or LEI are meant to appear on the website. The color of their nodes will be defined by the first year of TSI or LEI.

```jsonc
{
    "course": "string",         // one of: TSI, LEI, MEI, MRSI, MCD, MC, MAPi, ...
    "start_year": "int",        // first matriculation year
    "end_year": "int|null",     // last matriculation year (inclusive)
}
```


### Insignia

An emblem representing an organization, faina position or taça UA modality.

```jsonc
{
    "year": "int",      // matriculation year
    "name": "string",   // one of the following: NEI, AETTUA, ST, CS, CF, Handball, Athletics, Badminton, Basketball, Futsal, Natation, Voleibol, Football, TableTennis, Chess, ...
    "role": "string"    // variable, depending on the `name`
}
```


### Faina

The faina informations required for people who completed the faina.

```jsonc
{
    "eqv_years": "int",     // number of faina equivalence years in other courses before entering LEI/TSI
    "names": "array[FainaName]",
    "baptism_name": "string",
}
```


### FainaName

This object is so that it can deal with name changes during the years.

```jsonc
{
    "year": "int",      // last matriculation year when the name was defined/changed
    "name": "string",   // faina name
}
```
