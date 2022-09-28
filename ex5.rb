# Input đầu vào là hai mảng a và b không rỗng, viết hàm check xem mảng b
#  có là mảng con (cùng thứ tự) của a hay không?
# VD: a = [5, 1, 22, 26, 6, -1, 8, 10]
#        b = [1, 6, -1, 10]
# -> output: true
# Note: chỉ sử dụng 1 vòng for hoặc while trong hàm check của mình

# solve
# first element parent compare first element sub
require("./generate")

array_parent = Generate.generate_ramdom_array(100)
array_sub = Generate.generate_ramdom_array(10)

index_sub = 0
result = {}
array_parent.each_with_index do |value,index|
  if index_sub < array_sub.length && array_sub[index_sub] == value
    index_sub += 1
    result[index] = value
  end
end
puts index_sub == array_sub.length
puts result


# random array: [6, 1, 6, 3, 2, 7, 7, 0, 3, 0, 3, 7, 6, 4, 4, 7, 3, 6, 2, 2, 0, 3, 4, 4, 1, 8, 5, 1, 6, 5, 2, 4, 4, 1, 3, 2, 3, 5, 4, 0, 6, 6, 2, 7, 1, 0, 3, 7, 0, 2, 3, 7, 3, 0, 6, 0, 0, 3, 5, 6, 3, 4, 0, 3, 8, 4, 7, 3, 7, 5, 1, 7, 2, 0, 4, 0, 7, 4, 4, 0, 1, 4, 2, 2, 6, 1, 2, 2, 4, 3, 3, 7, 5, 7, 2, 4, 7, 4, 1, 7]
# random array: [3, 7, 2, 7, 5, 4, 1, 7, 6, 4]
# true
# {3=>3, 5=>7, 18=>2, 43=>7, 58=>5, 61=>4, 70=>1, 71=>7, 84=>6, 88=>4}
