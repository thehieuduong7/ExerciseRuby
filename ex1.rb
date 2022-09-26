# Nhập vào một mảng gồm n (n≤ 99) số tự nhiên từ bàn phím
# (quá trình nhập sẽ dừng khi người sử dụng nhập vào giá trị -1)
# sau đó hiển thị mảng vừa nhập và giá trị nhỏ nhất của mảng ra màn hình.
arr = []
loop do
	begin
		print 'input: '
		input = Integer(gets)
	rescue ArgumentError
		puts 'input number error'
		next
	end
	if input == -1
		puts arr.length == 0 ? "Array empty" : "Array(size=#{arr.length}): #{arr} \tMin: #{arr.min}"
		break
	end
	arr.push(input)
	if arr.length == 99
		puts "Array(size=#{arr.length}): #{arr} \tMin: #{arr.min}"
		break
	end
end
