# 7S-04-SIMPLE-STAR: simple_postgres

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_postgres
**Status**: Development (15 tests passing)

## Ecosystem Position

simple_postgres is a database-specific client alongside simple_sql (SQLite).

```
Database Layer:
├── simple_sql      (SQLite - embedded)
├── simple_postgres (PostgreSQL - server)
└── [future: simple_mysql, simple_mssql]
```

## Dependencies

| Library | Purpose | Required |
|---------|---------|----------|
| EiffelBase | Core types | Yes |
| libpq | PostgreSQL client | Yes (external) |

## Integration Pattern

### ECF Configuration
```xml
<library name="simple_postgres"
         location="$SIMPLE_EIFFEL/simple_postgres/simple_postgres.ecf"/>
```

### Environment Setup
```bash
export POSTGRESQL_HOME="C:\Program Files\PostgreSQL\18"
export PGPASSWORD="your_password"  # For testing
```

### Basic Usage
```eiffel
local
    db: SIMPLE_POSTGRES
do
    create db.make
    db.connect ("host=localhost dbname=test user=postgres")
    if db.is_connected then
        db.query ("SELECT * FROM users")
        if attached db.last_result as res then
            -- process results
            res.clear
        end
        db.disconnect
    end
end
```

## Ecosystem Conventions

1. **simple_ prefix** - Consistent naming
2. **DBC coverage** - Full contracts
3. **Void safe** - Complete
4. **SCOOP ready** - Compatible design
5. **Error pattern** - last_error/has_error
