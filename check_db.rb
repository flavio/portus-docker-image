def database_exists?
  ActiveRecord::Base.connection
rescue ActiveRecord::NoDatabaseError
  puts "DB_MISSING"
rescue Mysql2::Error
  puts "DB_DOWN"
else
  puts "DB_READY"
end

database_exists?
