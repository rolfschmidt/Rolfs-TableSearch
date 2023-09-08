# Rolfs-TableSearch

This package contains the functionality to search database tables of zammad via REST.

Be aware that this package is still in early development and will be reworked heavily in the next releases.

To use the endpoints you will need a admin with the permissions `admin.table_search`.

**Note: Do only use this package with PostgresSQL. There will be no MySQL support anymore, since it already deprecated.**

## Todo / Ideas

- [ ] Complex query syntax (`name IN (1,2,3) AND id: 1 AND title: "test"`)
- [ ] Tests

## How to install the package

1. Click in your admin interface to the area **Admin -> Packages**.

2. [Download the current version](https://github.com/rolfschmidt/Rolfs-TableSearch/releases) for the package which is compatible to your zammad version.

3. Install the package.

4. Run all displayed commands in the UI on your shell and restart your zammad service.

## Endpoints

### All tables

This endpoint shows all tables existing in zammad.

```bash
$ curl -s -uadmin@example.com:test http://ubuntu-rs:3000/api/v1/tables | jq .
{
  "ticket_flags": "Ticket::Flag",
  "ticket_priorities": "Ticket::Priority",
  "ticket_shared_draft_starts": "Ticket::SharedDraftStart",
  "ticket_shared_draft_zooms": "Ticket::SharedDraftZoom",
  "ticket_states": "Ticket::State",
  "ticket_state_types": "Ticket::StateType",
  "ticket_time_accounting_types": "Ticket::TimeAccounting::Type",
  "ticket_time_accountings": "Ticket::TimeAccounting",
  "tickets": "Ticket",
  ...
}
```

### Table columns

To get an overview over all columns of an table you can use this endpoint.

```bash
$ curl -s -u"admin@example.com:test" http://ubuntu-rs:3000/api/v1/tables/ticket_priorities/columns | jq .
{
  "id": "integer",
  "name": "string",
  "default_create": "boolean",
  "ui_icon": "string",
  "ui_color": "string",
  "note": "string",
  "active": "boolean",
  "updated_by_id": "integer",
  "created_by_id": "integer",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

### Select one row

If you only need one row then there is also a show endpoint:

```bash
$ curl -s -u"admin@example.com:test" http://ubuntu-rs:3000/api/v1/tables/ticket_priorities/1 | jq .
{
  "id": 1,
  "name": "1 low",
  "default_create": false,
  "ui_icon": "low-priority",
  "ui_color": "low-priority",
  "note": null,
  "active": true,
  "updated_by_id": 1,
  "created_by_id": 1,
  "created_at": "2023-09-04T10:45:15.514Z",
  "updated_at": "2023-09-04T10:45:15.548Z"
}
```

### Search endpoint

This is the magic endpoint which you can use for every table and where you can use the operators.

```bash
$ curl -s -uadmin@example.com:test http://ubuntu-rs:3000/api/v1/tables/ticket_priorities?id=1 | jq .
[
  {
    "id": 1,
    "name": "1 low",
    "default_create": false,
    "ui_icon": "low-priority",
    "ui_color": "low-priority",
    "note": null,
    "active": true,
    "updated_by_id": 1,
    "created_by_id": 1,
    "created_at": "2023-09-04T10:45:15.514Z",
    "updated_at": "2023-09-04T10:45:15.548Z"
  }
]
```

## Current operators

### Exact match

Exact values match for all columns.

```
http://ubuntu-rs:3000/api/v1/tables/tickets?id=1
http://ubuntu-rs:3000/api/v1/tables/tickets?id_not=1
```

### Date match

Range condtions for date columns.

`ge, gt, le, lt`

```
http://ubuntu-rs:3000/api/v1/tables/tickets?created_ge=2023-09-04T10:45:16.017Z
http://ubuntu-rs:3000/api/v1/tables/tickets?created_gt=2023-09-04T10:45:16.017Z
http://ubuntu-rs:3000/api/v1/tables/tickets?created_le=2023-09-04T10:45:16.017Z
http://ubuntu-rs:3000/api/v1/tables/tickets?created_lt=2023-09-04T10:45:16.017Z
```

### Search match

Fulltext search string columns.

```
http://ubuntu-rs:3000/api/v1/tables/tickets?search=Welcome
```

### Contains match

Contains for string columns.

```
http://ubuntu-rs:3000/api/v1/tables/tickets?title_contains=Welcome
http://ubuntu-rs:3000/api/v1/tables/tickets?title_contains_not=Welcome
```

### Regex match

Regex match for string columns

```
http://ubuntu-rs:3000/api/v1/tables/ticket_priorities?name_regex=(low|high)
http://ubuntu-rs:3000/api/v1/tables/ticket_priorities?name_regex_not=(low|high)
```

### Empty match

Empty match for string columns.

```
http://ubuntu-rs:3000/api/v1/tables/ticket_priorities?note_empty=1
http://ubuntu-rs:3000/api/v1/tables/ticket_priorities?note_empty_not=1
```

### Null match

Empty match for all columns.

```
http://ubuntu-rs:3000/api/v1/tables/ticket_priorities?note_null=1
http://ubuntu-rs:3000/api/v1/tables/ticket_priorities?note_null_not=1
```

### In array match

In array for all columns.

```
http://ubuntu-rs:3000/api/v1/tables/tickets?id_in=1,2,3
http://ubuntu-rs:3000/api/v1/tables/tickets?id_in_not=1,2,3
```

# LICENSE

MIT
