# S07-SPEC-SUMMARY: simple_postgres

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_postgres
**Status**: Development (15 tests passing)

## Executive Summary

simple_postgres provides PostgreSQL database access for Eiffel applications via a libpq wrapper with full Design by Contract support.

## Key Specifications

### Architecture
- **Pattern**: Facade wrapping internal connection
- **Main Class**: SIMPLE_POSTGRES
- **Connection**: PG_CONNECTION
- **Results**: PG_RESULT

### API Design
- **Connection String**: Standard PostgreSQL format
- **Query/Execute**: Separate methods for SELECT vs DML
- **NULL Handling**: value_at returns Void for NULL

### Features
1. Connection management
2. SELECT query execution
3. INSERT/UPDATE/DELETE execution
4. Affected row counts
5. Result set navigation
6. NULL value handling
7. Column metadata
8. Transaction support (via SQL)

### Dependencies
- EiffelBase (standard)
- libpq (PostgreSQL C API)

### Platform Support
- Windows (with PostgreSQL installed)
- Linux (with libpq)
- macOS (with libpq)

## Contract Highlights

- Must not be connected before connect
- Must be connected for queries
- SQL must be non-empty
- Results must be cleared to free memory

## Performance Targets

| Operation | Target |
|-----------|--------|
| Connect | <100ms |
| Simple query | <10ms |
| Disconnect | <1ms |
