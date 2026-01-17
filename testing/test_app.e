note
	description: "Test runner application for simple_postgres"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run the tests.
		do
			print ("Running SIMPLE_POSTGRES tests...%N%N")
			passed := 0
			failed := 0

			run_lib_tests

			print ("%N========================%N")
			print ("Results: " + passed.out + " passed, " + failed.out + " failed%N")

			if failed > 0 then
				print ("TESTS FAILED%N")
			else
				print ("ALL TESTS PASSED%N")
			end
		end

feature {NONE} -- Test Runners

	run_lib_tests
			-- Run LIB_TESTS test cases.
		do
			create lib_tests

			-- Happy Path Tests
			print ("--- Happy Path Tests ---%N")
			run_test (agent lib_tests.test_creation, "test_creation")
			run_test (agent lib_tests.test_connect_disconnect, "test_connect_disconnect")
			run_test (agent lib_tests.test_execute_ddl, "test_execute_ddl")
			run_test (agent lib_tests.test_insert_and_query, "test_insert_and_query")
			run_test (agent lib_tests.test_column_names, "test_column_names")
			run_test (agent lib_tests.test_affected_rows, "test_affected_rows")
			run_test (agent lib_tests.test_reconnect, "test_reconnect")
			run_test (agent lib_tests.test_utf8_data, "test_utf8_data")
			run_test (agent lib_tests.test_transaction, "test_transaction")

			-- Edge Case Tests
			print ("%N--- Edge Case Tests ---%N")
			run_test (agent lib_tests.test_invalid_connection, "test_invalid_connection")
			run_test (agent lib_tests.test_invalid_sql, "test_invalid_sql")
			run_test (agent lib_tests.test_null_values, "test_null_values")
			run_test (agent lib_tests.test_empty_result, "test_empty_result")
			run_test (agent lib_tests.test_multiple_queries, "test_multiple_queries")
			run_test (agent lib_tests.test_special_characters, "test_special_characters")
		end

feature {NONE} -- Implementation

	lib_tests: LIB_TESTS

	passed: INTEGER
	failed: INTEGER

	run_test (a_test: PROCEDURE; a_name: STRING)
			-- Run a single test and update counters.
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				a_test.call (Void)
				print ("  PASS: " + a_name + "%N")
				passed := passed + 1
			end
		rescue
			print ("  FAIL: " + a_name + "%N")
			failed := failed + 1
			l_retried := True
			retry
		end

end
