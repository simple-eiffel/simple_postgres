# S04-FEATURE-SPECS: simple_postgres

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_postgres
**Status**: Development (15 tests passing)

## SIMPLE_POSTGRES Features

### Creation
| Feature | Signature | Description |
|---------|-----------|-------------|
| make | `make` | Create disconnected client |

### Connection
| Feature | Signature | Description |
|---------|-----------|-------------|
| connect | `connect (a_connection_string: STRING)` | Connect to database |
| disconnect | `disconnect` | Close connection |
| is_connected | `is_connected: BOOLEAN` | Check connection status |

### Queries
| Feature | Signature | Description |
|---------|-----------|-------------|
| query | `query (a_sql: STRING)` | Execute SELECT |
| execute | `execute (a_sql: STRING)` | Execute INSERT/UPDATE/DELETE |

### Results
| Feature | Signature | Description |
|---------|-----------|-------------|
| last_result | `last_result: detachable PG_RESULT` | Last query result |
| last_error | `last_error: STRING` | Last error message |
| affected_rows | `affected_rows: INTEGER` | Rows affected by execute |

## PG_RESULT Features

### Navigation
| Feature | Signature | Description |
|---------|-----------|-------------|
| row_count | `row_count: INTEGER` | Number of rows |
| column_count | `column_count: INTEGER` | Number of columns |
| is_empty | `is_empty: BOOLEAN` | No rows returned |

### Value Access
| Feature | Signature | Description |
|---------|-----------|-------------|
| value_at | `value_at (row, col): detachable STRING` | Get value (Void if NULL) |
| is_null_at | `is_null_at (row, col): BOOLEAN` | Check if NULL |
| column_name | `column_name (col): STRING` | Get column name |

### Lifecycle
| Feature | Signature | Description |
|---------|-----------|-------------|
| is_valid | `is_valid: BOOLEAN` | Result still valid |
| clear | `clear` | Free result memory |
