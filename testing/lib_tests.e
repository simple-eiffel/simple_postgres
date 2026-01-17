note
	description: "[
		Test cases for simple_postgres library.

		Requires local PostgreSQL with:
		- Default postgres database accessible
		- User: postgres (or current Windows user with trust auth)

		Tests create/drop a test table, so safe to run repeatedly.
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	LIB_TESTS

inherit
	TEST_SET_BASE

feature -- Test Configuration

	test_connection_string: STRING = "host=localhost port=5432 dbname=postgres user=postgres"
			-- Connection string for local PostgreSQL
			-- Password is read from PGPASSWORD environment variable

feature -- Happy Path Tests

	test_creation
			-- Test that SIMPLE_POSTGRES can be created.
		local
			l_db: SIMPLE_POSTGRES
		do
			create l_db.make
			assert ("created", l_db /= Void)
			assert ("not_connected_initially", not l_db.is_connected)
			assert ("no_error_initially", l_db.last_error.is_empty)
		end

	test_connect_disconnect
			-- Test basic connect and disconnect cycle.
		local
			l_db: SIMPLE_POSTGRES
		do
			create l_db.make

			l_db.connect (test_connection_string)
			assert ("connected", l_db.is_connected)
			assert ("no_connect_error", l_db.last_error.is_empty)

			l_db.disconnect
			assert ("disconnected", not l_db.is_connected)
		end

	test_execute_ddl
			-- Test executing DDL statements (CREATE/DROP TABLE).
		local
			l_db: SIMPLE_POSTGRES
		do
			create l_db.make
			l_db.connect (test_connection_string)

			-- Drop table if exists (ignore errors)
			l_db.execute ("DROP TABLE IF EXISTS simple_postgres_test")

			-- Create test table
			l_db.execute ("CREATE TABLE simple_postgres_test (id SERIAL PRIMARY KEY, name VARCHAR(100), value INTEGER)")
			assert ("create_table_no_error", l_db.last_error.is_empty)

			-- Clean up
			l_db.execute ("DROP TABLE simple_postgres_test")
			assert ("drop_table_no_error", l_db.last_error.is_empty)

			l_db.disconnect
		end

	test_insert_and_query
			-- Test INSERT and SELECT operations.
		local
			l_db: SIMPLE_POSTGRES
		do
			create l_db.make
			l_db.connect (test_connection_string)

			-- Setup
			l_db.execute ("DROP TABLE IF EXISTS simple_postgres_test")
			l_db.execute ("CREATE TABLE simple_postgres_test (id SERIAL PRIMARY KEY, name VARCHAR(100), value INTEGER)")

			-- Insert data
			l_db.execute ("INSERT INTO simple_postgres_test (name, value) VALUES ('Alice', 100)")
			assert ("insert_1_no_error", l_db.last_error.is_empty)

			l_db.execute ("INSERT INTO simple_postgres_test (name, value) VALUES ('Bob', 200)")
			assert ("insert_2_no_error", l_db.last_error.is_empty)

			-- Query data
			l_db.query ("SELECT name, value FROM simple_postgres_test ORDER BY name")
			assert ("query_no_error", l_db.last_error.is_empty)

			if attached l_db.last_result as res then
				assert ("has_2_rows", res.row_count = 2)
				assert ("has_2_columns", res.column_count = 2)

				-- First row: Alice
				assert ("row_0_name", attached res.value_at (0, 0) as v and then v.same_string ("Alice"))
				assert ("row_0_value", attached res.value_at (0, 1) as v and then v.same_string ("100"))

				-- Second row: Bob
				assert ("row_1_name", attached res.value_at (1, 0) as v and then v.same_string ("Bob"))
				assert ("row_1_value", attached res.value_at (1, 1) as v and then v.same_string ("200"))

				res.clear
			else
				assert ("result_attached", False)
			end

			-- Cleanup
			l_db.execute ("DROP TABLE simple_postgres_test")
			l_db.disconnect
		end

	test_column_names
			-- Test retrieving column names from result.
		local
			l_db: SIMPLE_POSTGRES
		do
			create l_db.make
			l_db.connect (test_connection_string)

			l_db.query ("SELECT 1 AS first_col, 2 AS second_col")

			if attached l_db.last_result as res then
				assert ("col_0_name", res.column_name (0).same_string ("first_col"))
				assert ("col_1_name", res.column_name (1).same_string ("second_col"))
				res.clear
			else
				assert ("result_attached", False)
			end

			l_db.disconnect
		end

feature -- Edge Case Tests

	test_invalid_connection
			-- Test connection with invalid parameters.
		local
			l_db: SIMPLE_POSTGRES
		do
			create l_db.make

			l_db.connect ("host=invalid_host_that_does_not_exist port=5432 dbname=postgres connect_timeout=1")

			assert ("not_connected", not l_db.is_connected)
			assert ("has_error", not l_db.last_error.is_empty)
		end

	test_invalid_sql
			-- Test executing invalid SQL.
		local
			l_db: SIMPLE_POSTGRES
		do
			create l_db.make
			l_db.connect (test_connection_string)

			l_db.query ("SELECT * FROM table_that_does_not_exist_xyz")

			assert ("has_error", not l_db.last_error.is_empty)
			assert ("no_result", l_db.last_result = Void)

			l_db.disconnect
		end

	test_null_values
			-- Test handling of NULL values in results.
		local
			l_db: SIMPLE_POSTGRES
		do
			create l_db.make
			l_db.connect (test_connection_string)

			-- Setup
			l_db.execute ("DROP TABLE IF EXISTS simple_postgres_test")
			l_db.execute ("CREATE TABLE simple_postgres_test (id SERIAL PRIMARY KEY, name VARCHAR(100))")
			l_db.execute ("INSERT INTO simple_postgres_test (name) VALUES (NULL)")

			-- Query
			l_db.query ("SELECT name FROM simple_postgres_test")

			if attached l_db.last_result as res then
				assert ("has_row", res.row_count = 1)
				assert ("is_null", res.is_null_at (0, 0))
				assert ("value_is_void", res.value_at (0, 0) = Void)
				res.clear
			else
				assert ("result_attached", False)
			end

			-- Cleanup
			l_db.execute ("DROP TABLE simple_postgres_test")
			l_db.disconnect
		end

	test_empty_result
			-- Test query that returns no rows.
		local
			l_db: SIMPLE_POSTGRES
		do
			create l_db.make
			l_db.connect (test_connection_string)

			-- Setup
			l_db.execute ("DROP TABLE IF EXISTS simple_postgres_test")
			l_db.execute ("CREATE TABLE simple_postgres_test (id SERIAL PRIMARY KEY)")

			-- Query empty table
			l_db.query ("SELECT * FROM simple_postgres_test")

			if attached l_db.last_result as res then
				assert ("no_rows", res.row_count = 0)
				assert ("is_empty", res.is_empty)
				res.clear
			else
				assert ("result_attached", False)
			end

			-- Cleanup
			l_db.execute ("DROP TABLE simple_postgres_test")
			l_db.disconnect
		end

	test_multiple_queries
			-- Test running multiple queries in sequence.
		local
			l_db: SIMPLE_POSTGRES
			i: INTEGER
		do
			create l_db.make
			l_db.connect (test_connection_string)

			-- Run 10 queries
			from i := 1 until i > 10 loop
				l_db.query ("SELECT " + i.out + " AS num")
				if attached l_db.last_result as res then
					assert ("query_" + i.out + "_result", attached res.value_at (0, 0) as v and then v.same_string (i.out))
					res.clear
				end
				i := i + 1
			end

			l_db.disconnect
		end

	test_special_characters
			-- Test handling of special characters in data.
		local
			l_db: SIMPLE_POSTGRES
		do
			create l_db.make
			l_db.connect (test_connection_string)

			-- Setup
			l_db.execute ("DROP TABLE IF EXISTS simple_postgres_test")
			l_db.execute ("CREATE TABLE simple_postgres_test (id SERIAL PRIMARY KEY, data TEXT)")

			-- Insert with special chars (use $$ quoting for safety)
			l_db.execute ("INSERT INTO simple_postgres_test (data) VALUES ('Hello ''World'' with quotes')")

			-- Query
			l_db.query ("SELECT data FROM simple_postgres_test")

			if attached l_db.last_result as res then
				assert ("special_chars", attached res.value_at (0, 0) as v and then v.has_substring ("World"))
				res.clear
			else
				assert ("result_attached", False)
			end

			-- Cleanup
			l_db.execute ("DROP TABLE simple_postgres_test")
			l_db.disconnect
		end

end
