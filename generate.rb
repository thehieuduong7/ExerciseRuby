require 'csv'
require 'date'
require 'time'

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

  # generate array numbers
  def self.generate_ramdom_array(size)
    arr = []
    size.times {arr.push(rand(9))}
    puts "random array: #{arr}"
    arr
  end
end

# p Generate.generate_ramdom_array(4)
