# S01-PROJECT-INVENTORY: simple_postgres

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_postgres
**Status**: Development (15 tests passing)

## Project Structure

```
simple_postgres/
├── src/
│   ├── simple_postgres.e        # Main facade class
│   ├── pg_connection.e          # Connection management
│   ├── pg_result.e              # Result set handling
│   ├── pg_row.e                 # Row accessor
│   ├── pg_externals.e           # libpq C externals
│   ├── pg_error.e               # Error codes
│   └── pg_type_oids.e           # PostgreSQL type OIDs
├── bin/
│   └── [placeholder]
├── testing/
│   ├── application.e            # Test runner
│   └── test_*.e                 # Test classes
├── docs/
│   └── index.html               # API documentation
├── simple_postgres.ecf          # Library configuration
├── README.md                    # User documentation
├── CHANGELOG.md                 # Version history
└── .gitignore
```

## ECF Configuration

- **Library Target**: simple_postgres
- **Test Target**: simple_postgres_tests
- **UUID**: Unique per library
- **Dependencies**: EiffelBase, libpq (external)

## External Requirements

- PostgreSQL 12+ installation
- POSTGRESQL_HOME environment variable
- libpq.dll/libpq.so available

## Build Artifacts

- EIFGENs/simple_postgres/ - Library compilation
- EIFGENs/simple_postgres_tests/ - Test compilation
