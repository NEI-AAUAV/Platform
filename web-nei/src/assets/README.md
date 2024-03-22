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
  "id": "objectId",         // automatic generated ID
  "name": "string",
  "sex": "string",          // "M"ale or "F"emale
  "image": "string|null",   // profile image URL from NEI-API

  "matriculations": "array[Matriculation]",
  "organizations": "array[Organization]",
  "faina": "Faina|null"     // null if did not do/complete the faina
}
```

### Matriculation

Only people with TSI or LEI are meant to appear on the website. The color of their nodes will be defined by the first year of TSI or LEI.

```jsonc
{
  "course": "string",       // one of: TSI, LEI, MEI, MRSI, MCD, MC, MAPi, ...
  "start_year": "int",      // first matriculation year
  "end_year": "int|null"    // last matriculation year (inclusive)
}
```

### Organization

An emblem representing an organization, faina position or taça UA modality.

```jsonc
{
  "name": "string",   // one of the following: AAUAV, NEI, AETTUA, ST, CS, CF, TaçaUA
  // Handball, Athletics, Badminton, Basketball, Futsal, Swimming, Voleyball, Football, TableTennis, Chess, ...
  "role": "string",   // optional and variable, depends on the `name` field
  "year": "int",      // matriculation year
}
```

### Faina

The faina informations required for people who **have a faina family**.

```jsonc
{
    "parent_id": "int",        // patrão/patroa ID
    "baptism_name": "string",
    "details": "FainaDetails|null"  // FIXME: can i create indexes here?
}
```

### FainaDetails

The faina informations required for people who **completed the faina**.

```jsonc
{
    "eqv_years": "int",               // number of faina equivalence years in other courses before entering LEI/TSI
    "name": "string|array[string]",   // array deals with name changes during the years.
    "organizations": "array[Organization]",
}
```
