require "csv"
require "date"
require 'time'

require "pg"


module Generate
  HEADER = ["name","Email","Phone","Address","Day_of_Birth","Profile"].freeze
  CITIES = ["HCM","HN","Da Nang","Quang Tri"].freeze

  def self.generate_name()
    "Nguyen Van A" + rand(100).to_s
  end
  def self.generate_email(name)
    name.gsub! ' ', ''
    name.downcase + "@gmail.com"
  end
  def self.generate_phone()
    numbers = "'0"
    for i in 0..8
      numbers = numbers + rand(10).to_s
    end
    return numbers
  end
  def self.generate_time()
    from = Time.new(1988,1,1)
    to = Time.now
    Time.at(from + rand * (to.to_f - from.to_f))
  end
  def self.generate_address(arr)
    len = arr.length
    arr[rand(len)]
  end

  def self.generate_special_character

    chars = ('!'..'?').to_a
    "Some special charactor "+chars.shuffle().join
  end

  def self.generate_array
    name = generate_name
    email = generate_email(name.to_s)
    phone = generate_phone
    address = generate_address(CITIES)
    dob = generate_time().strftime("%Y/%m/%d")
    profile = generate_special_character
    [name,email,phone,address,dob,profile]
  end

  def self.generate_file(file_name) #file/new_films.csv
    CSV.open(file_name, "w") do |csv|
      csv << Generate::HEADER
      count = 0
      while count < 500000 do
        count += 1
        csv << Generate.generate_array
      end
    end
  end
end

starting = Time.now

class PostgreSQLDB
  @@CONFIG = {
    "port"  => "5433",
    "host" =>  "localhost",
    "user" => "postgres",
    "password" => "123456",
    "dbname" => "ruby_intern"
  }.freeze
  attr_reader :CONFIG
  def initialize()
    @@connection ||= PG::Connection.open(@@CONFIG) or abort "Unable to create a new connection!"
    @@connection.prepare('insert', 'insert into users values ($1, $2, $3, $4, $5, $6)')
 end

  def migration_table()
    @@connection.exec("DROP table users")
    @@connection.exec( "CREATE TABLE IF NOT EXISTS users (
      name VARCHAR(50) ,
      Email VARCHAR(50),
      Phone VARCHAR(50) ,
      Address VARCHAR(500) ,
      Day_of_Birth TIMESTAMP ,
      Profile VARCHAR(500)
      );" )
  end
  def insert_user(user = {})
    @@connection.exec_prepared('insert',
       [ user["name"],user["Email"],user["Phone"],
       user["Address"],Time.parse(user["Day_of_Birth"]),
       user["Profile"] ])
  end
  def import_csv(file_name,headers=true) #'file/new_films.csv'
    count = 0
    CSV.foreach(file_name,headers: headers) do |row|
      user = row.to_hash
      insert_user(user)
      count += 1
    end
  end
end

postgre = PostgreSQLDB.new.insert_user()
# puts PostgreSQLDB.new.migration_table()
# p Generate.generate_file("file/new_films.csv")

#"name","Email","Phone","Address","Day_of_Birth","Profile"
# conn = PG::Connection.open(PostgreSQLDB.new.CONFIG)
# conn.exec( "select * from accounts" ) do |result|
#   puts "     PID | User             | Query"
#   result.each do |row|
#     puts " %7d | %-16s | %s " %
#       row.values_at('account_number', 'user_id', 'surplus')
#   end
# end



ending = Time.now
elapsed = ending - starting
puts elapsed # => 10.822178
