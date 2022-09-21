require "csv"
require "date"
starting = Time.now

module Generate
  HEADER = ["name","Email","Phone","Address","Day_of_Birth","Profile"]
  CITIES = ["HCM","HN","Da Nang","Quang Tri"]

  def self.generateName()
    "Nguyen Van A" + rand(100).to_s
  end
  def self.generateEmail(name)
    name.gsub! ' ', ''
    name.downcase + "@gmail.com"
  end
  def self.generatePhone()
    numbers = "0"
    for i in 0..8
      numbers = numbers + rand(10).to_s
    end
    return numbers
  end
  def self.generateTime()
    from = Time.new(1988,1,1)
    to = Time.now
    Time.at(from + rand * (to.to_f - from.to_f))
  end
  def self.generateAddress(arr)
    len = arr.length
    arr[rand(len)]
  end
  def self.generateSpecialCharacter()
    chars = ('!'..'?').to_a
    "Some special charactor "+chars.shuffle().join
  end
  def self.generateArr()

    name =generateName()
    email = generateEmail(name)
    phone = generatePhone()
    address =generateAddress(CITIES)
    dob = generateTime().strftime("%Y/%m/%d")
    profile = generateSpecialCharacter()
    return [name,email,phone,address,dob,profile]
  end
end





CSV.open("file/new_films.csv", "w") do |csv|
  csv << Generate::HEADER
  for i in 0...500000
    csv<< Generate.generateArr()
  end
end

ending = Time.now
elapsed = ending - starting
puts elapsed # => 10.822178
