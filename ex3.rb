# Khởi tạo một mảng random gồm n (n≤ 99) số tự nhiên, với n nhập từ bàn phím, các phần tử trong mảng từ 1 đến 9.
#  Sau đó hiển thị các dãy con tăng trong mảng
# Vd: mảng được khởi tạo ngẫu nhiên là: [6, 8, 2, 5, 3, 6, 1, 2, 7, 1]
# Output:
#  + mảng con tăng 1: 6, 8
#  + mảng con tăng 2: 2, 5
#  + mảng con tăng 3: 3, 6
#  + mảng con tăng 4: 1, 2, 7
#  + mảng con tăng 5: 1
def generate_ramdom_arr(size)
  arr = []
  i = 0
  loop do
    arr.push(rand(9))
    i += 1
    return arr if i == size
  end
end

def sub_arr( arr )
  count = 0
  print_sub_arr = lambda do |input|
    count += 1
    puts "sub arr #{count}: #{input}"
  end
  temp = []
  arr.each do |i|
    if temp.length.zero? || temp[-1] < i
      temp.push(i)
    else
      print_sub_arr.call(arr)
      temp = [i]
    end
  end
  # Last sub array
  print_sub_arr.call(arr)
end

begin
  print 'input n: '
  n = Integer(gets)
  arr = generate_ramdom_arr(n)
  puts "random array: #{arr}"
  sub_arr(arr)
rescue ArgumentError
  puts 'input number error'
end
