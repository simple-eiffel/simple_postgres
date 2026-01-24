# 7S-01-SCOPE: simple_postgres

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_postgres
**Status**: Development (15 tests passing)

## Problem Statement

Eiffel applications need to connect to PostgreSQL databases. No modern, void-safe, SCOOP-compatible PostgreSQL client exists for Eiffel.

## Target Users

1. **Enterprise Developers** - PostgreSQL is the #1 open-source RDBMS
2. **Web Application Developers** - Backend database access
3. **Data Processing Systems** - ETL and analytics
4. **Migration Projects** - Moving from other databases

## Core Capabilities

1. **Connection Management** - Connect/disconnect with connection strings
2. **Query Execution** - SELECT queries with result sets
3. **DML Support** - INSERT/UPDATE/DELETE with affected row counts
4. **Transaction Support** - BEGIN/COMMIT/ROLLBACK
5. **NULL Handling** - Proper detection and handling
6. **Column Metadata** - Access column names
7. **UTF-8 Support** - Full Unicode

## Out of Scope

- Connection pooling (application responsibility)
- ORM functionality (use simple_persist)
- Prepared statements (future enhancement)
- COPY protocol
- Async queries
- SSL certificate management

## Success Criteria

1. Connect to PostgreSQL 12-18
2. Execute queries in under 10ms overhead
3. Handle NULL values correctly
4. Support transactions
5. Full Design by Contract coverage
