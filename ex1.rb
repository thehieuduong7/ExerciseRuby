n = 0;
arr = []
loop do
	input = gets.to_i
	if input == -1
		puts n==0 ? "Array empty" : "Array(size=#{arr.length}): #{arr} \tMin: #{arr.min}"
		break
	end
	arr.append(input)
	n=n+1
	if(n==99)
		puts "Array(size=#{arr.length}): #{arr} \tMin: #{arr.min}"
		break
	end
end
