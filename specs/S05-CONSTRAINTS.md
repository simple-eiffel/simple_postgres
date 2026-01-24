# S05-CONSTRAINTS: simple_postgres

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_postgres
**Status**: Development (15 tests passing)

## Technical Constraints

### External Requirements
- PostgreSQL 12-18 installation
- libpq library accessible
- POSTGRESQL_HOME environment variable

### Connection String Format
```
host=<host> port=<port> dbname=<database> user=<user> password=<password>
```

Optional parameters:
- sslmode (disable, require, verify-ca, verify-full)
- connect_timeout (seconds)
- application_name

### Result Set Constraints
- Row indices: 0-based
- Column indices: 0-based
- Must call clear() to free memory
- Invalid after disconnect

### Thread Safety
- One connection per thread
- Results tied to connection
- Not shareable across threads

## API Constraints

### Connection
- Must disconnect before reconnect
- Must be connected for queries
- Must handle connection errors

### Queries
- SQL must be non-empty
- Results must be cleared
- Transactions via SQL (BEGIN/COMMIT/ROLLBACK)

### NULL Handling
- value_at returns Void for NULL
- is_null_at for explicit check

## Invariants

### Connection State
- connection handle valid when connected
- last_error always attached

### Result State
- handle valid until cleared
- row/column counts non-negative
