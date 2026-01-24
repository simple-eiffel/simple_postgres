# 7S-03-SOLUTIONS: simple_postgres

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_postgres
**Status**: Development (15 tests passing)

## Alternative Solutions Considered

### 1. EiffelStore PostgreSQL (Rejected)
- **Approach**: Use ISE's EiffelStore with PostgreSQL adapter
- **Pros**: Standard library
- **Cons**: Complex API, poor void safety, SCOOP issues
- **Decision**: Rejected - too heavy, compatibility issues

### 2. ODBC Bridge (Rejected)
- **Approach**: Use ODBC with PostgreSQL driver
- **Pros**: Database-agnostic
- **Cons**: Extra layer, configuration overhead
- **Decision**: Rejected - unnecessary complexity

### 3. Direct libpq Wrapper (Chosen)
- **Approach**: Wrap libpq directly with inline C
- **Pros**: Best performance, native API, full control
- **Cons**: C interop required
- **Decision**: Selected - optimal solution

### 4. Pure Eiffel Implementation (Rejected)
- **Approach**: Implement wire protocol directly
- **Pros**: No C dependencies
- **Cons**: Massive effort, SSL complexity
- **Decision**: Rejected - reinventing libpq

## Architecture Decisions

1. **SIMPLE_POSTGRES facade** - Single entry point
2. **PG_CONNECTION internal** - Connection lifecycle
3. **PG_RESULT handle** - Result set management
4. **PG_EXTERNALS** - Centralized C externals
5. **Inline C pattern** - No separate .c files
