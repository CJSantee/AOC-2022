$debug = false

def read_file(filename)
	f = File.open(filename)
	instructions = []
	while line = f.gets&.strip do 
		instructions.append(line)
	end
	f.close
	return instructions
end

def part_one(instructions)
	cycle = 1
	register = 1
	sum_signal_strength = 0
	instructions.each do |instruction|
		if ((cycle-20)%40==0)
			sum_signal_strength += register*cycle
		end
		if (instruction == "noop")
			# noop
			cycle += 1
		else
			# addx
			value = instruction.split(' ').last.to_i
			cycle += 1
			if ((cycle-20)%40==0)
				sum_signal_strength += register*cycle
			end
			cycle +=1
			register += value
		end
	end
	return sum_signal_strength
end

def part_two(instructions)
	cycle = 1
	register = 1
	row, col = 0, 0
	crt = ['']
	instructions.each do |instruction|
		command = instruction.split(' ').first
		value = instruction.split(' ').last&.to_i

		puts "Start cycle   #{cycle}: begin executing #{instruction}" if $debug
		puts "During cycle  #{cycle}: CRT draws pixel in position #{cycle-1}" if $debug
		# Draw Pixel
		if (col >= register - 1 && col <= register + 1)
			crt[row] += "#"
		else
			crt[row] += "." 
		end
		col += 1

		if (col == 40)
			crt.append('')
			row += 1
			col = 0
		end
		puts "Current CRT row: #{crt[row]}" if $debug

		if (command == "addx")
			cycle += 1
			print "\n" if $debug
			puts "During cycle  #{cycle}: CRT draws pixel in position #{cycle-1}" if $debug
			# Draw Pixel
			if (col >= register - 1 && col <= register + 1)
				crt[row] += "#"
			else
				crt[row] += "." 
			end
			col += 1
			if (col == 40)
				crt.append('')
				row += 1
				col = 0
			end
			puts "Current CRT row: #{crt[row]}" if $debug

			register += value
			puts "End of cycle #{cycle}: finish executing #{instruction} (Register X is now #{register})" if $debug

			print "Sprite position: " if $debug
			for idx in 0..39 do 
				if (idx >= register - 1 && idx <= register + 1)
					print "#" if $debug
				else
					print "." if $debug
				end
			end
			print "\n" if $debug
		end
		cycle += 1 
		print "\n" if $debug
	end
	crt.each do |r|
		puts r
	end
end

instructions = read_file("input.txt")

# Part One
puts "What is the sum of these six signal strengths?"
puts part_one(instructions)

# Part Two 
puts "What eight capital letters appear on your CRT?"
part_two(instructions)