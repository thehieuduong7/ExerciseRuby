# Khởi tạo một mảng random gồm n (n≤ 99) số tự nhiên, với n nhập từ bàn phím, các phần tử trong mảng từ 1 đến 9.
#  Sau đó hiển thị các dãy con tăng trong mảng
# Vd: mảng được khởi tạo ngẫu nhiên là: [6, 8, 2, 5, 3, 6, 1, 2, 7, 1]
# Output:
#  + mảng con tăng 1: 6, 8
#  + mảng con tăng 2: 2, 5
#  + mảng con tăng 3: 3, 6
#  + mảng con tăng 4: 1, 2, 7
#  + mảng con tăng 5: 1

# if sub not increment, next sub array
require("./ulti")

def sub_arr(arr, &handle)
  temp = []
  arr.each do |i|
    if temp.length.zero? || temp[-1] < i
      temp.push(i)
    else
      handle.call(temp)
      temp = [i]
    end
  end
  # Last sub array
  handle.call(temp)
end

n = IOConsole.input_int("Input n:")
arr = Generate.generate_ramdom_array(n)
puts "Random array #{arr}"
count = 0
sub_arr(arr) do |input|
  count += 1
  puts "sub arr #{count}: #{input}"
end


# input n: 10
# random array: [4, 2, 4, 8, 3, 5, 6, 7, 6, 4]
# sub arr 1: [4]
# sub arr 2: [2, 4, 8]
# sub arr 3: [3, 5, 6, 7]
# sub arr 4: [6]
# sub arr 5: [4]
