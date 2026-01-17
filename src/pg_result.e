note
	description: "PostgreSQL query result set with row/column access."
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	PG_RESULT

inherit
	PG_EXTERNALS

create
	make

feature {NONE} -- Initialization

	make (a_result_handle: POINTER)
			-- Initialize with result handle from query execution.
		require
			handle_valid: a_result_handle /= default_pointer
		do
			result_handle := a_result_handle
			row_count := c_pqntuples (result_handle)
			column_count := c_pqnfields (result_handle)
		ensure
			handle_set: result_handle = a_result_handle
			is_valid: is_valid
		end

feature -- Access

	row_count: INTEGER
			-- Number of rows in result

	column_count: INTEGER
			-- Number of columns in result

	value_at (a_row, a_col: INTEGER): detachable STRING
			-- Value at row/column position (0-indexed).
			-- Returns Void if value is NULL.
		require
			is_valid: is_valid
			row_valid: a_row >= 0 and a_row < row_count
			col_valid: a_col >= 0 and a_col < column_count
		local
			l_ptr: POINTER
			l_c_string: C_STRING
		do
			if c_pqgetisnull (result_handle, a_row, a_col) = 0 then
				l_ptr := c_pqgetvalue (result_handle, a_row, a_col)
				if l_ptr /= default_pointer then
					create l_c_string.make_by_pointer (l_ptr)
					Result := l_c_string.string
				end
			end
		end

	column_name (a_col: INTEGER): STRING
			-- Name of column at index (0-indexed).
		require
			is_valid: is_valid
			col_valid: a_col >= 0 and a_col < column_count
		local
			l_ptr: POINTER
			l_c_string: C_STRING
		do
			l_ptr := c_pqfname (result_handle, a_col)
			if l_ptr /= default_pointer then
				create l_c_string.make_by_pointer (l_ptr)
				Result := l_c_string.string
			else
				Result := ""
			end
		ensure
			result_attached: Result /= Void
		end

	is_null_at (a_row, a_col: INTEGER): BOOLEAN
			-- Is value at row/column NULL?
		require
			is_valid: is_valid
			row_valid: a_row >= 0 and a_row < row_count
			col_valid: a_col >= 0 and a_col < column_count
		do
			Result := c_pqgetisnull (result_handle, a_row, a_col) = 1
		end

feature -- Status Report

	is_valid: BOOLEAN
			-- Is result handle valid?
		do
			Result := result_handle /= default_pointer
		end

	is_empty: BOOLEAN
			-- Does result have no rows?
		do
			Result := row_count = 0
		end

feature -- Cleanup

	clear
			-- Free result memory. Result becomes invalid after this.
		require
			is_valid: is_valid
		do
			c_pqclear (result_handle)
			result_handle := default_pointer
			row_count := 0
			column_count := 0
		ensure
			not_valid: not is_valid
			no_rows: row_count = 0
			no_cols: column_count = 0
		end

feature {NONE} -- Implementation

	result_handle: POINTER
			-- Internal libpq PGresult handle

invariant
	row_count_non_negative: row_count >= 0
	column_count_non_negative: column_count >= 0

end