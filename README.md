<p align="center">
  <img src="https://raw.githubusercontent.com/simple-eiffel/claude_eiffel_op_docs/main/artwork/LOGO.png" alt="simple_ library logo" width="400">
</p>

# simple_postgres

**[Documentation](https://simple-eiffel.github.io/simple_postgres/)** | **[GitHub](https://github.com/simple-eiffel/simple_postgres)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Eiffel](https://img.shields.io/badge/Eiffel-25.02-blue.svg)](https://www.eiffel.org/)
[![Design by Contract](https://img.shields.io/badge/DbC-enforced-orange.svg)]()
[![Built with simple_codegen](https://img.shields.io/badge/Built_with-simple__codegen-blueviolet.svg)](https://github.com/simple-eiffel/simple_code)

PostgreSQL client library for Eiffel using libpq. Connect to databases, execute queries, and process results with full Design by Contract support.

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

**Development** - 15 tests passing

## Overview

SIMPLE_POSTGRES provides a facade for PostgreSQL database operations. It wraps libpq with Eiffel idioms, offering connection management, query execution, result set access, NULL handling, and transaction support.

## Features

- **Connection Management** - Connect/disconnect with connection string
- **Query Execution** - SELECT queries with result sets
- **DML Support** - INSERT/UPDATE/DELETE with affected row counts
- **Transaction Support** - BEGIN/COMMIT/ROLLBACK
- **NULL Handling** - Proper detection and handling of NULL values
- **Column Metadata** - Access column names from results
- **UTF-8 Support** - Full Unicode character support
- **Design by Contract** - Full preconditions, postconditions, invariants
- **Void Safe** - Fully void-safe implementation
- **SCOOP Compatible** - Ready for concurrent use

## Installation

1. Install PostgreSQL and set environment variable:
```bash
export POSTGRESQL_HOME="C:\Program Files\PostgreSQL\18"
export PGPASSWORD="your_password"
```

2. Set the ecosystem environment variable:
```bash
export SIMPLE_EIFFEL=D:\prod
```

3. Add to your ECF:
```xml
<library name="simple_postgres" location="$SIMPLE_EIFFEL/simple_postgres/simple_postgres.ecf"/>
```

## Quick Start

### Basic Query

```eiffel
local
    db: SIMPLE_POSTGRES
do
    create db.make
    db.connect ("host=localhost dbname=mydb user=postgres")

    if db.is_connected then
        db.query ("SELECT name, email FROM users")
        if attached db.last_result as res then
            across 0 |..| (res.row_count - 1) as row loop
                print (res.value_at (row, 0) + ": " + res.value_at (row, 1) + "%N")
            end
            res.clear
        end
        db.disconnect
    end
end
```

### Insert with Affected Rows

```eiffel
db.execute ("INSERT INTO users (name) VALUES ('Alice'), ('Bob')")
print ("Inserted: " + db.affected_rows.out + " rows%N")
```

### Transaction

```eiffel
db.execute ("BEGIN")
db.execute ("UPDATE accounts SET balance = balance - 100 WHERE id = 1")
db.execute ("UPDATE accounts SET balance = balance + 100 WHERE id = 2")
db.execute ("COMMIT")
```

## API Reference

### SIMPLE_POSTGRES (Facade)

| Feature | Description |
|---------|-------------|
| `make` | Create disconnected client |
| `connect (conn_string)` | Connect to database |
| `disconnect` | Close connection |
| `is_connected` | Check connection status |
| `query (sql)` | Execute SELECT, store result |
| `execute (sql)` | Execute INSERT/UPDATE/DELETE |
| `last_result` | Result from last query |
| `last_error` | Error message (empty if none) |
| `affected_rows` | Rows affected by last execute |

### PG_RESULT

| Feature | Description |
|---------|-------------|
| `row_count` | Number of rows |
| `column_count` | Number of columns |
| `value_at (row, col)` | Get value (Void if NULL) |
| `column_name (col)` | Get column name |
| `is_null_at (row, col)` | Check if value is NULL |
| `is_empty` | Check if no rows |
| `clear` | Free result memory |

## Dependencies

- PostgreSQL libpq (via POSTGRESQL_HOME environment variable)
- EiffelBase

## License

MIT License - Copyright (c) 2024-2025, Larry Rix
