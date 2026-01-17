note
	description: "Debug test to see connection error"

class
	DEBUG_TEST

create
	make

feature
	make
		local
			l_db: SIMPLE_POSTGRES
		do
			create l_db.make
			print ("Attempting connection...%N")
			l_db.connect ("host=localhost port=5432 dbname=postgres")
			print ("is_connected: " + l_db.is_connected.out + "%N")
			print ("last_error: [" + l_db.last_error + "]%N")
			if l_db.is_connected then
				l_db.disconnect
			end
		end

end
