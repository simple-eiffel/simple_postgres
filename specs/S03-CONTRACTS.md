# S03-CONTRACTS: simple_postgres

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_postgres
**Status**: Development (15 tests passing)

## SIMPLE_POSTGRES Contracts

### make
```eiffel
make
    ensure
        not_connected: not is_connected
        no_result: last_result = Void
```

### connect
```eiffel
connect (a_connection_string: STRING)
    require
        not_connected: not is_connected
        connection_string_valid: a_connection_string /= Void and then
                                  not a_connection_string.is_empty
    ensure
        connected_or_error: is_connected or not last_error.is_empty
```

### disconnect
```eiffel
disconnect
    require
        connected: is_connected
    ensure
        not_connected: not is_connected
        no_result: last_result = Void
```

### query
```eiffel
query (a_sql: STRING)
    require
        connected: is_connected
        sql_valid: a_sql /= Void and then not a_sql.is_empty
    ensure
        result_or_error: last_result /= Void or not last_error.is_empty
        error_cleared_on_success: last_result /= Void implies last_error.is_empty
        still_connected: is_connected
```

### execute
```eiffel
execute (a_sql: STRING)
    require
        connected: is_connected
        sql_valid: a_sql /= Void and then not a_sql.is_empty
    ensure
        error_cleared_on_success: last_error.is_empty implies affected_rows >= 0
        error_set_on_failure: not last_error.is_empty implies affected_rows = 0
        still_connected: is_connected
```

## Invariants

### SIMPLE_POSTGRES
```eiffel
invariant
    connection_attached: connection /= Void
    last_error_attached: last_error /= Void
```

### PG_CONNECTION
```eiffel
invariant
    last_error_attached: last_error /= Void
```
