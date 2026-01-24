# S06-BOUNDARIES: simple_postgres

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_postgres
**Status**: Development (15 tests passing)

## System Boundaries

### Component Architecture

```
+-------------------+
|   Application     |
+--------+----------+
         |
         v
+--------+----------+
|  SIMPLE_POSTGRES  |
|     (Facade)      |
+--------+----------+
         |
         v
+--------+----------+
|   PG_CONNECTION   |
|   (Connection)    |
+--------+----------+
         |
         v
+--------+----------+
|   PG_EXTERNALS    |
|  (C Externals)    |
+--------+----------+
         |
         v
+--------+----------+
|      libpq        |
| (PostgreSQL C API)|
+--------+----------+
         |
         v
+--------+----------+
| PostgreSQL Server |
+-------------------+
```

### Input Boundaries

| Input | Source | Validation |
|-------|--------|------------|
| Connection String | Caller | Non-empty |
| SQL Query | Caller | Non-empty |
| Row Index | Caller | 0 to row_count-1 |
| Column Index | Caller | 0 to column_count-1 |

### Output Boundaries

| Output | Target | Format |
|--------|--------|--------|
| PG_RESULT | Caller | Result set object |
| Values | Caller | STRING (or Void) |
| affected_rows | Caller | INTEGER |
| Errors | Caller | STRING |

## Dependency Boundaries

### Required
- EiffelBase (core types)
- libpq (PostgreSQL client library)

### Environment
- POSTGRESQL_HOME (install location)
- PGPASSWORD (optional, for password)

## Trust Boundaries

### Trusted
- libpq library
- PostgreSQL server (when connected)

### Untrusted
- SQL queries (injection risk)
- Result data (may be unexpected)
