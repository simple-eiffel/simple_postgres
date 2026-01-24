# 7S-02-STANDARDS: simple_postgres

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_postgres
**Status**: Development (15 tests passing)

## Applicable Standards

### PostgreSQL Standards
- **libpq** - Official C client library
- **PostgreSQL Wire Protocol** - v3.0 (via libpq)
- **SQL:2016** - Query syntax support

### Connection String Format
```
host=localhost port=5432 dbname=mydb user=postgres password=secret
```

### Result Status Codes
| Code | Constant | Meaning |
|------|----------|---------|
| 0 | PGRES_EMPTY_QUERY | Empty query string |
| 1 | PGRES_COMMAND_OK | Command completed |
| 2 | PGRES_TUPLES_OK | Query returned rows |
| 3 | PGRES_COPY_OUT | COPY OUT in progress |
| 4 | PGRES_COPY_IN | COPY IN in progress |
| 5 | PGRES_BAD_RESPONSE | Server response error |
| 6 | PGRES_NONFATAL_ERROR | Warning/notice |
| 7 | PGRES_FATAL_ERROR | Query failed |

## Type OIDs (Common)
| Type | OID |
|------|-----|
| BOOL | 16 |
| INT4 | 23 |
| INT8 | 20 |
| TEXT | 25 |
| VARCHAR | 1043 |
| DATE | 1082 |
| TIMESTAMP | 1114 |

## Design Patterns

1. **Facade Pattern** - SIMPLE_POSTGRES wraps PG_CONNECTION
2. **Result Set Pattern** - PG_RESULT for query results
3. **External Interface** - PG_EXTERNALS for libpq calls
