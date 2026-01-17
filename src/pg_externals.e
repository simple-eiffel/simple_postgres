note
	description: "Low-level C external declarations for libpq PostgreSQL client library."
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	PG_EXTERNALS

feature -- Connection

	c_pqconnectdb (a_conninfo: POINTER): POINTER
			-- Connect to database using connection string.
			-- Returns PGconn pointer or NULL on failure.
		external
			"C inline use <libpq-fe.h>"
		alias
			"return PQconnectdb((const char*)$a_conninfo);"
		end

	c_pqfinish (a_conn: POINTER)
			-- Close connection and free memory.
		external
			"C inline use <libpq-fe.h>"
		alias
			"PQfinish((PGconn*)$a_conn);"
		end

	c_pqstatus (a_conn: POINTER): INTEGER
			-- Return connection status.
			-- 0 = CONNECTION_OK, 1 = CONNECTION_BAD
		external
			"C inline use <libpq-fe.h>"
		alias
			"return (EIF_INTEGER)PQstatus((PGconn*)$a_conn);"
		end

	c_pqerrormessage (a_conn: POINTER): POINTER
			-- Return error message for connection.
		external
			"C inline use <libpq-fe.h>"
		alias
			"return (char*)PQerrorMessage((PGconn*)$a_conn);"
		end

feature -- Query Execution

	c_pqexec (a_conn: POINTER; a_query: POINTER): POINTER
			-- Execute SQL query.
			-- Returns PGresult pointer.
		external
			"C inline use <libpq-fe.h>"
		alias
			"return PQexec((PGconn*)$a_conn, (const char*)$a_query);"
		end

	c_pqresultstatus (a_result: POINTER): INTEGER
			-- Return result status.
			-- 0=EMPTY, 1=COMMAND_OK, 2=TUPLES_OK, etc.
		external
			"C inline use <libpq-fe.h>"
		alias
			"return (EIF_INTEGER)PQresultStatus((PGresult*)$a_result);"
		end

	c_pqresulterrormessage (a_result: POINTER): POINTER
			-- Return error message for result.
		external
			"C inline use <libpq-fe.h>"
		alias
			"return (char*)PQresultErrorMessage((PGresult*)$a_result);"
		end

feature -- Result Access

	c_pqntuples (a_result: POINTER): INTEGER
			-- Return number of rows in result.
		external
			"C inline use <libpq-fe.h>"
		alias
			"return (EIF_INTEGER)PQntuples((PGresult*)$a_result);"
		end

	c_pqnfields (a_result: POINTER): INTEGER
			-- Return number of columns in result.
		external
			"C inline use <libpq-fe.h>"
		alias
			"return (EIF_INTEGER)PQnfields((PGresult*)$a_result);"
		end

	c_pqgetvalue (a_result: POINTER; a_row, a_col: INTEGER): POINTER
			-- Return value at row/column as C string pointer.
		external
			"C inline use <libpq-fe.h>"
		alias
			"return PQgetvalue((PGresult*)$a_result, (int)$a_row, (int)$a_col);"
		end

	c_pqfname (a_result: POINTER; a_col: INTEGER): POINTER
			-- Return column name.
		external
			"C inline use <libpq-fe.h>"
		alias
			"return PQfname((PGresult*)$a_result, (int)$a_col);"
		end

	c_pqgetisnull (a_result: POINTER; a_row, a_col: INTEGER): INTEGER
			-- Return 1 if value is NULL, 0 otherwise.
		external
			"C inline use <libpq-fe.h>"
		alias
			"return (EIF_INTEGER)PQgetisnull((PGresult*)$a_result, (int)$a_row, (int)$a_col);"
		end

feature -- Result Cleanup

	c_pqclear (a_result: POINTER)
			-- Free result memory.
		external
			"C inline use <libpq-fe.h>"
		alias
			"PQclear((PGresult*)$a_result);"
		end

feature -- Status Constants

	Connection_ok: INTEGER = 0
	Connection_bad: INTEGER = 1

	Pgres_empty_query: INTEGER = 0
	Pgres_command_ok: INTEGER = 1
	Pgres_tuples_ok: INTEGER = 2
	Pgres_bad_response: INTEGER = 5
	Pgres_fatal_error: INTEGER = 7

end