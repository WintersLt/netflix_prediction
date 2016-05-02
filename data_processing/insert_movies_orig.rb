# This will use DATA LOAD and call on each movie file
#  - A LOT faster than doing inserts.

require "dbi"

 begin
  # connect to the MySQL server
  dbh = DBI.connect("dbi:Mysql:netflix:localhost", "root", "")

  row = dbh.select_one("SELECT VERSION()")
  p "Running on version: " + row[0]
  movieCount = 12771

  result = dbh.do("SET FOREIGN_KEY_CHECKS = 0;")
  result = dbh.do("SET UNIQUE_CHECKS = 0;")
  result = dbh.do("SET SESSION tx_isolation='READ-UNCOMMITTED';")
  result = dbh.do("SET sql_log_bin = 0;")
  p result
  #1.upto(17770) do |n|
  12771.upto(17770) do |n|
      movie = Dir.getwd << "//data_load//ratings.#{n.to_s.rjust(7, '0')}.txt"
      result = dbh.do("LOAD DATA INFILE '#{movie}' INTO TABLE ratings FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'")
      p "#{movieCount} : #{result}" if movieCount % 100 == 0

      movieCount = movieCount + 1
  end

 rescue DBI::DatabaseError => e
     p "An error occurred"
     p "Error code: #{e.err}"
     p "Error message: #{e.errstr}"
 ensure
     p "Exiting on: #{movieCount}"
     dbh.disconnect if dbh
 end

 #"Exiting on: 4521"
 # some missing from 4800 to 4900
