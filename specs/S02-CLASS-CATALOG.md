# S02-CLASS-CATALOG: simple_postgres

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_postgres
**Status**: Development (15 tests passing)

## Class Hierarchy

```
ANY
├── SIMPLE_POSTGRES         # Main facade
├── PG_CONNECTION           # Connection wrapper
│   └── PG_EXTERNALS       # (inherited)
├── PG_RESULT              # Result set
│   └── PG_EXTERNALS       # (inherited)
├── PG_ROW                 # Row accessor
├── PG_EXTERNALS           # C external declarations
├── PG_ERROR               # Error code constants
└── PG_TYPE_OIDS           # Type OID constants
```

## Class Descriptions

### SIMPLE_POSTGRES (Facade)
Main entry point for PostgreSQL operations.
- **Creation**: `make`
- **Purpose**: Simplified API for database operations

### PG_CONNECTION
Connection lifecycle management.
- **Creation**: `make`
- **Purpose**: Connect, execute, disconnect

### PG_RESULT
Query result set handling.
- **Creation**: `make (handle)`
- **Purpose**: Navigate rows, access values

### PG_ROW
Row-level value accessor.
- **Purpose**: Named column access to current row

### PG_EXTERNALS
Centralized libpq external declarations.
- **Purpose**: All C external function declarations

### PG_ERROR
PostgreSQL error code constants.
- **Purpose**: PGRES_* status codes

### PG_TYPE_OIDS
PostgreSQL type OID constants.
- **Purpose**: Type identification (INT4, TEXT, etc.)
