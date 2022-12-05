# Part One
puts "In how many assignment pairs does one range fully contain the other?"

f = File.open('input.txt')

count = 0
while line = f.gets do 
	first, second = line.split(',')
	first_start, first_end = first.split('-').map(&:to_i)
	second_start, second_end = second.split('-').map(&:to_i)

	if((first_start <= second_start && first_end >= second_end) || (second_start <= first_start && second_end >= first_end))
		count += 1
	end
end

puts count
f.close

# Part Two 
puts "In how many assignment pairs do the ranges overlap?"

f = File.open('input.txt')

count = 0
while line = f.gets do 
	first, second = line.split(',')
	first_start, first_end = first.split('-').map(&:to_i)
	second_start, second_end = second.split('-').map(&:to_i)
	
	if((second_start <= first_end && second_end >= first_end) || (first_start <= second_end && first_end >= second_end))
		count += 1
	end
end

puts count
f.close