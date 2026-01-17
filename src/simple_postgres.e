note
	description: "[
		Simple PostgreSQL client library facade.
		
		Provides easy-to-use API for PostgreSQL database operations.
		Wraps libpq with Eiffel idioms and Design by Contract.
		
		Usage:
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
	]" 
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_POSTGRES

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize disconnected database client.
		do
			create connection.make
			create last_error.make_empty
		ensure
			not_connected: not is_connected
			no_result: last_result = Void
		end

feature -- Access

	last_result: detachable PG_RESULT
			-- Result from last query operation.
			-- Void if no query executed or query failed.

	last_error: STRING
			-- Last error message (empty if no error)

	affected_rows: INTEGER
			-- Number of rows affected by last execute command

feature -- Status Report

	is_connected: BOOLEAN
			-- Is database connection open?
		do
			Result := connection.is_connected
		end

feature -- Connection Operations

	connect (a_connection_string: STRING)
			-- Connect to PostgreSQL database.
			-- Connection string format: "host=localhost port=5432 dbname=mydb user=postgres password=secret"
		require
			not_connected: not is_connected
			connection_string_valid: a_connection_string /= Void and then not a_connection_string.is_empty
		do
			last_error.wipe_out
			connection.connect (a_connection_string)
			if not connection.is_connected then
				last_error := connection.last_error.twin
			end
		ensure
			connected_or_error: is_connected or not last_error.is_empty
		end

	disconnect
			-- Close database connection.
		require
			connected: is_connected
		do
			-- Clear any pending result (only if not already cleared by user)
			if attached last_result as res and then res.is_valid then
				res.clear
			end
			last_result := Void
			connection.disconnect
			last_error.wipe_out
		ensure
			not_connected: not is_connected
			no_result: last_result = Void
		end

feature -- Query Operations

	query (a_sql: STRING)
			-- Execute SELECT query and store result in `last_result'.
			-- Previous result is automatically cleared.
		require
			connected: is_connected
			sql_valid: a_sql /= Void and then not a_sql.is_empty
		local
			l_handle: POINTER
		do
			-- Clear previous result (only if not already cleared by user)
			if attached last_result as res and then res.is_valid then
				res.clear
			end
			last_result := Void
			
			last_error.wipe_out
			l_handle := connection.execute (a_sql)
			
			if l_handle /= default_pointer and then connection.last_error.is_empty then
				create last_result.make (l_handle)
			else
				last_error := connection.last_error.twin
				if l_handle /= default_pointer then
					-- Clear failed result handle
					(create {PG_EXTERNALS}).c_pqclear (l_handle)
				end
			end
		ensure
			result_or_error: last_result /= Void or not last_error.is_empty
			error_cleared_on_success: last_result /= Void implies last_error.is_empty
			still_connected: is_connected
		end

	execute (a_sql: STRING)
			-- Execute INSERT/UPDATE/DELETE command.
			-- Sets `affected_rows' on success.
		require
			connected: is_connected
			sql_valid: a_sql /= Void and then not a_sql.is_empty
		local
			l_handle: POINTER
			l_ext: PG_EXTERNALS
			l_cmd_tuples_ptr: POINTER
			l_c_string: C_STRING
		do
			last_error.wipe_out
			affected_rows := 0
			l_handle := connection.execute (a_sql)

			if l_handle /= default_pointer and then connection.last_error.is_empty then
				create l_ext
				-- Use PQcmdTuples for INSERT/UPDATE/DELETE affected row count
				l_cmd_tuples_ptr := l_ext.c_pqcmdtuples (l_handle)
				if l_cmd_tuples_ptr /= default_pointer then
					create l_c_string.make_by_pointer (l_cmd_tuples_ptr)
					if l_c_string.string.is_integer then
						affected_rows := l_c_string.string.to_integer
					end
				end
				l_ext.c_pqclear (l_handle)
			else
				last_error := connection.last_error.twin
				if l_handle /= default_pointer then
					(create {PG_EXTERNALS}).c_pqclear (l_handle)
				end
			end
		ensure
			error_cleared_on_success: last_error.is_empty implies affected_rows >= 0
			error_set_on_failure: not last_error.is_empty implies affected_rows = 0
			still_connected: is_connected
		end

feature {NONE} -- Implementation

	connection: PG_CONNECTION
			-- Internal connection handler

invariant
	connection_attached: connection /= Void
	last_error_attached: last_error /= Void

end