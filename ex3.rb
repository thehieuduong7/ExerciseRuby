# "Khởi tạo một mảng random gồm n (n≤ 99) số tự nhiên, với n nhập từ bàn phím, các phần tử trong mảng từ 1 đến 9.
#  Sau đó hiển thị các dãy con tăng trong mảng
# Vd: mảng được khởi tạo ngẫu nhiên là: [6, 8, 2, 5, 3, 6, 1, 2, 7, 1]
# Output:
#  + mảng con tăng 1: 6, 8
#  + mảng con tăng 2: 2, 5
#  + mảng con tăng 3: 3, 6
#  + mảng con tăng 4: 1, 2, 7
#  + mảng con tăng 5: 1"

n = gets.to_i
arr = []
i = 0
while i < n
  i += 1
  arr.push(rand(9))
end
puts "random array: #{arr.to_s}"

$count = 0
def print_sub_arr(arr)
  $count += 1
  puts "sub arr #{$count}: #{arr.to_s}"
end

temp = []
for i in arr
  if temp.length == 0 || (temp[-1] && temp[-1] < i)
    temp.push(i)
  else
    print_sub_arr(temp)
    temp = [i]
  end
end
print_sub_arr(temp) #last sub array
