require 'csv'
require 'date'
require 'time'
require 'pg'

#  Module seed data
module Generate
  HEADER = ['name', 'Email', 'Phone', 'Address', 'Day_of_Birth', 'Profile'].freeze
  CITIES = ['HCM', 'HN', 'Da Nang', 'Quang Tri'].freeze
  def self.generate_name
    "Nguyen Van A #{rand(100)}"
  end

  def self.generate_email(name)
    name.gsub! ' ', ''
    "#{name.downcase}@gmail.com"
  end

  def self.generate_phone
    numbers = '0'
    0..8.each { numbers += rand(10).to_s }
    numbers
  end

  def self.generate_time
    from = Time.new(1988, 1, 1)
    to = Time.now
    Time.at(from + rand * (to.to_f - from.to_f))
  end

  def self.generate_address(arr)
    len = arr.length
    arr[rand(len)]
  end

  def self.generate_special_character
    chars = ('!'..'?').to_a
    "Some special charactor #{chars.shuffle.join}"
  end

  # generate array information user
  def self.generate_array
    name = generate_name
    email = generate_email(name.to_s)
    phone = generate_phone
    address = generate_address(CITIES)
    dob = generate_time.strftime('%Y/%m/%d')
    profile = generate_special_character
    [name, email, phone, address, dob, profile]
  end

  # create file csv File/new_films.csv
  def self.generate_file(file_name)
    CSV.open(file_name, 'w') do |csv|
      csv << Generate::HEADER
      count = 0
      while count < 500000 do
        count += 1
        csv << Generate.generate_array
      end
    end
  end
end

# Connection Postgres
class PostgreSQLDB
  # Localhost
  @@CONFIG = {
    'port'  => '5433',
    'host' =>  'localhost',
    'user' => 'postgres',
    'password' => '123456',
    'dbname' => 'ruby_intern'
  }.freeze

  # Clound
  # @@CONFIG = {
  #   'host' =>  'tiny.db.elephantsql.com',
  #   'user' => 'firawucy',
  #   'password' => 'mQcnqxtGGDWVnTGxo_GQf7bLtNLsNX2h',
  #   'dbname' => 'firawucy'
  # }.freeze
  # attr_reader :CONFIG

  def initialize
    @@connection ||= PG::Connection.open(@@CONFIG) or abort 'Unable to create a new connection!'
  end

  def migration_table
    @@connection.exec('DROP TABLE IF EXISTS users')
    @@connection.exec('CREATE TABLE IF NOT EXISTS users (
      name VARCHAR(50) ,
      Email VARCHAR(50),
      Phone VARCHAR(50) ,
      Address VARCHAR(500) ,
      Day_of_Birth TIMESTAMP ,
      Profile VARCHAR(500)
      );')
    @@connection.prepare('insert', 'insert into users values ($1, $2, $3, $4, $5, $6)')
  end

  def insert_user(user = {})
    @@connection.exec_prepared('insert',[ user['name'],
        user['Email'],
        user['Phone'],
        user['Address'],
        Time.parse(user['Day_of_Birth']),
        user['Profile']
      ])
  end

  # 'file/new_films.csv'
  def import_csv(file_name, headers: true)
    count = 0
    CSV.foreach(file_name, headers: headers) do |row|
      user = row.to_hash
      insert_user(user)
      count += 1
    end
  end

  def copy_from_csv(file_name)
    @@connection.transaction do
      @@connection.exec( "COPY users FROM STDIN WITH csv" )
      begin
        CSV.foreach(file_name, headers: true) do |row|
          user = row.to_s
          until @@connection.put_copy_data(user) do
            $stderr.puts "	waiting for connection to be writable..."
          end
        end
      rescue Errno => err
        errmsg = "%s while reading copy data: %s" % [ err.class.name, err.message ]
        @@connection.put_copy_end( errmsg )

      else
        @@connection.put_copy_end
        while res = @@connection.get_result
          $stderr.puts "Result of COPY is: %s" % [ res.res_status(res.result_status) ]
        end
      end
    end
  end
  def copy_all_csv(file_name)
    sql = "copy users(name, Email, Phone, Address, Day_of_Birth, Profile) FROM \'#{file_name}\' DELIMITER ',' HEADER CSV;"
    @@connection.exec(sql)
  end
end

starting = Time.now
pgdb = PostgreSQLDB.new
pgdb.migration_table
pgdb.copy_all_csv('D:\BackUp\Work\bestarion\ruby\exercise\file\new_films.csv')


# CSV.foreach("file/new_films.csv", headers: true) do |row|
#   user = row.to_s
#   p user
#   break
# end

# p Generate.generate_file('file/new_films.csv')
ending = Time.now
elapsed = ending - starting
puts elapsed # =>2.2662333
