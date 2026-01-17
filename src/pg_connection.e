note
	description: "PostgreSQL connection wrapper with lifecycle management."
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	PG_CONNECTION

inherit
	PG_EXTERNALS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize disconnected connection.
		do
			create last_error.make_empty
		ensure
			not_connected: not is_connected
			no_error: last_error.is_empty
		end

feature -- Access

	last_error: STRING
			-- Last error message from connection or query

feature -- Status Report

	is_connected: BOOLEAN
			-- Is connection currently open and valid?
		do
			Result := connection_handle /= default_pointer and then
			          c_pqstatus (connection_handle) = Connection_ok
		end

feature -- Connection Operations

	connect (a_connection_string: STRING)
			-- Connect to database using connection string.
			-- Format: "host=localhost dbname=mydb user=postgres password=secret"
		require
			not_connected: not is_connected
			connection_string_valid: a_connection_string /= Void and then not a_connection_string.is_empty
		local
			l_c_string: C_STRING
		do
			last_error.wipe_out
			create l_c_string.make (a_connection_string)
			connection_handle := c_pqconnectdb (l_c_string.item)
			
			if connection_handle = default_pointer then
				last_error := "Failed to allocate connection"
			elseif c_pqstatus (connection_handle) /= Connection_ok then
				last_error := pointer_to_string (c_pqerrormessage (connection_handle))
				c_pqfinish (connection_handle)
				connection_handle := default_pointer
			end
		ensure
			connected_or_error: is_connected or not last_error.is_empty
		end

	disconnect
			-- Close connection and release resources.
		require
			connected: is_connected
		do
			c_pqfinish (connection_handle)
			connection_handle := default_pointer
			last_error.wipe_out
		ensure
			not_connected: not is_connected
		end

feature -- Query Execution

	execute (a_sql: STRING): POINTER
			-- Execute SQL and return result handle.
			-- Caller must call c_pqclear on result when done.
		require
			connected: is_connected
			sql_valid: a_sql /= Void and then not a_sql.is_empty
		local
			l_c_string: C_STRING
			l_status: INTEGER
		do
			last_error.wipe_out
			create l_c_string.make (a_sql)
			Result := c_pqexec (connection_handle, l_c_string.item)
			
			if Result /= default_pointer then
				l_status := c_pqresultstatus (Result)
				if l_status /= Pgres_command_ok and l_status /= Pgres_tuples_ok then
					last_error := pointer_to_string (c_pqresulterrormessage (Result))
				end
			else
				last_error := "Query execution failed: null result"
			end
		ensure
			result_or_error: Result /= default_pointer or not last_error.is_empty
		end

feature {NONE} -- Implementation

	connection_handle: POINTER
			-- Internal libpq PGconn handle

	pointer_to_string (a_ptr: POINTER): STRING
			-- Convert C string pointer to Eiffel STRING.
		local
			l_c_string: C_STRING
		do
			if a_ptr = default_pointer then
				Result := ""
			else
				create l_c_string.make_by_pointer (a_ptr)
				Result := l_c_string.string
			end
		ensure
			result_attached: Result /= Void
		end

invariant
	last_error_attached: last_error /= Void

end