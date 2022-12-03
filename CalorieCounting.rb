# Part One
puts "Find the Elf carrying the most Calories. How many total Calories is that Elf carrying?"

f = File.open("input.txt")
max_cal = 0
elf_cal = 0
while line = f.gets do 
	if(line == "\n")
		if elf_cal > max_cal
			max_cal = elf_cal
		end
		elf_cal = 0
	else
		elf_cal += line.to_i
	end
end

puts max_cal
f.close

# Part Two
puts "Find the top three Elves carrying the most Calories. How many Calories are those Elves carrying in total?"

f = File.open("input.txt")
max_high = 0
max_mid = 0
max_low = 0
elf_cal = 0
while line = f.gets do 
	if(line == "\n")
		# Recalculate max
		if(elf_cal > max_high)
			max_low = max_mid # Don't forget to update the lower two
			max_mid = max_high
			max_high = elf_cal
		elsif(elf_cal > max_mid)
			max_low = max_mid # Don't forget to update the lower one
			max_mid = elf_cal
		elsif(elf_cal > max_low)
			max_low = elf_cal
		end
		elf_cal = 0
	else
		elf_cal += line.to_i
	end
end

puts max_high + max_mid + max_low
f.close