# Transforms movie_id.txt into a 'DATA LOAD'able format for MySQL
#  - Assuming table is: [movie_id, user_id, rating, date]
#  - Not the most efficient solution - for people on unix/linux, you can apparently pipe the data into DATA LOAD directly (google is your friend)

begin
    1.upto(17770) do |n|
      out = File.open("data_load/ratings.#{n.to_s.rjust(7, '0')}.txt", "w")

      File.open("./download/training_set/mv_#{n.to_s.rjust(7, '0')}.txt", "r") do |ratings|
        ratings.each_line { |rating|
          if rating =~ /(\d+),(\d+),(.*)/
            userid, rating, date = rating.scan(/(\d+),(\d+),(.*)/).flatten
			if (date.include?("2003")) || (date.include?("2004")) || (date.include? ("2005"))
             out.write("#{n},#{userid},#{rating},#{date}\n")
			end
          end
        }
      end
     end

     out.close
rescue => err
      out.close
      puts "Exception: #{err}"
end
