require 'pg'
require("./ulti")

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
    begin
    @@connection ||= PG::Connection.open(@@CONFIG)
    rescue PG::ConnectionBad => e
      abort e.to_s
    end
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
    begin
      @@connection.exec(sql)
      puts "copy from file '#{file_name}' success!!"
    rescue PG::UndefinedFile => e
      puts e
    end
  end
end

# Generate.generate_file("file/new_films.csv")
pgdb = PostgreSQLDB.new
pgdb.migration_table
starting = Time.now
pgdb.copy_all_csv('D:\BackUp\Work\bestarion\ruby\exercise\file\new_films.csv')
ending = Time.now
elapsed = ending - starting
puts elapsed # =>2.2662333
