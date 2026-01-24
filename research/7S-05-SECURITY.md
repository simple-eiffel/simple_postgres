# 7S-05-SECURITY: simple_postgres

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_postgres
**Status**: Development (15 tests passing)

## Threat Model

### Assets
1. Database credentials
2. Query data
3. Connection handles
4. Result set data

### Threat Actors
1. SQL injection attackers
2. Network eavesdroppers
3. Memory dumpers
4. Privilege escalation

## Security Considerations

### SQL Injection
- **Risk**: User input in queries
- **Mitigation**: Use parameterized queries (not yet implemented)
- **Current**: Application must sanitize input

### Credential Management
- **Risk**: Passwords in connection strings
- **Mitigation**: Use PGPASSWORD env var or .pgpass file
- **Never**: Hard-code passwords

### Network Security
- **SSL**: Supported via libpq connection string
- **sslmode**: verify-full recommended for production
- **Example**: "host=db sslmode=verify-full sslrootcert=/path/ca.crt"

### Memory Security
- **Result clearing**: Call res.clear to free memory
- **Connection closing**: Always disconnect
- **Password exposure**: Connection string may be logged

## Recommendations

1. Use environment variables for passwords
2. Enable SSL in production
3. Sanitize all user input
4. Clear results promptly
5. Close connections on error
6. Use least-privilege database users

## Out of Scope
- Prepared statements (future)
- Certificate management
- Connection encryption negotiation
