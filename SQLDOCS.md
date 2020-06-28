# SQL Docs

None of the fields in this document should ever be null.

## Table: `Articles`

- `ID`: ID type (or long), autoincrement
- `Title`: string
- `URL`: string
- `ImageURL`: string
- `Date`: long (or SQL date/time type)
- `Category`: string

## Table: `ReadArticles`

- `ArticleID`: ID type (or long)
- `DateRead`: long (or SQL date/time type)
- `Username`: string
