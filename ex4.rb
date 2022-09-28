# Viết chương trình trong đó có hàm nhận input đầu vào là một mảng không rỗng và
# các phần tử trong mảng không trùng nhau (có thể bao gồm số âm), và một con số đại diện cho tổng (target_sum).
# Nếu 2 số trong một mảng có tổng bằng với target_sum, in ra mảng với 2 số đó. Nếu không có in ra mảng rỗng
# Lưu ý: chỉ sử dụng 1 vòng lặp for hoặc while (nếu khó quá thì có thể sử dụng vòng for không lồng vào nhau).
#  Chỉ cần in ra 1 mảng đầu tiên tìm thấy
# Vd: input là mảng
#   numbers = [3, 5, -4, 8, 11, 1, -1, 6]
#   target_sum = 10
# => output sẽ là [11, -1]

# solve
# save list value in hash

require("./generate")

begin
  print 'input n: '
  n = Integer(gets)
rescue ArgumentError
  puts 'input number error'
  retry
end

array_input = Generate.generate_ramdom_array(n)
target = rand(10..20)
puts "Target #{target}"

module Ex4
  def self.find_elements(array, target)
    values = {}
    array.each do |i|
      need = target - i
      if values[need]
        return [need, i]
      else
        values[i] = true
      end
    end
    []
  end
end


puts Ex4.find_elements(array_input,target).to_s


# input n: 20
# random array: [7, 3, 0, 1, 8, 1, 4, 3, 2, 0, 4, 3, 3, 3, 1, 7, 1, 4, 4, 3]
# Target 19
# []

# input n: 10
# random array: [4, 5, 3, 0, 3, 8, 2, 8, 4, 8]
# Target 12
# [4, 8]
