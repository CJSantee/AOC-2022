# Part One
puts "After the rearrangement procedure completes, what crate ends up on top of each stack?";

def read_file(filename)
	f = File.open('input.txt')
	crate_input = []
	instructions = []
	reading = 'crates'
	while line = f.gets do 
		if (line == "\n")	
			reading = 'instructions'
		elsif (reading == 'crates')
			crate_input.append(line)
		else 
			instructions.append(line)
		end
	end
	f.close
	return crate_input, instructions
end

def get_crates(crate_input)
	num_crates = crate_input[crate_input.length - 1].split(' ').map(&:to_i).last
	height_of_highest_crate = crate_input.length - 1

	crates = Array.new(num_crates) { Array.new(0) }

	for idx in 0..height_of_highest_crate-1 do 
		characters = crate_input[idx].split('')
		crate_idx = 0
		characters.each.with_index do |char, idx|
			if ((idx+1) % 4 == 2)
				crates[crate_idx%num_crates].unshift(char)
				crate_idx += 1
			end
		end
	end

	for idx in 0..num_crates-1 do 
		crates[idx] = crates[idx].filter {|item| item != " "}
	end
	return crates
end

def print_crates(crates)
	crates.each.with_index do |crate, idx|
		print "#{idx+1}: #{crate}\n"
	end
end

def part_one(crates, instructions)
	instructions.each do |instruction|
		before_from, after_from = instruction.split('from')
		num_to_move = before_from.split(' ').last.to_i
		move_from, move_to = after_from.split(' to ').map(&:strip).map(&:to_i)

		for move in 1..num_to_move do
			moving_crate = crates[move_from - 1].pop 
			crates[move_to - 1].append(moving_crate)
		end
		# puts "move #{num_to_move} from #{move_from} to #{move_to}"
	end
	crates.each do |crate|
		print crate.pop
	end
	print "\n"
end

def part_two(crates, instructions)
	instructions.each do |instruction|
		before_from, after_from = instruction.split('from')
		num_to_move = before_from.split(' ').last.to_i
		move_from, move_to = after_from.split(' to ').map(&:strip).map(&:to_i)

		# puts "move #{num_to_move} from #{move_from} to #{move_to}"
		cargo = []
		for moving in 1..num_to_move do 
			cargo.unshift(crates[move_from-1].pop)
		end
		crates[move_to - 1] += cargo
	end
	crates.each do |crate|
		print crate.pop
	end
	print "\n"
end

crate_input, instructions = read_file('input.txt')
crates = get_crates(crate_input)
part_one(crates, instructions)

# Part Two
puts "After the rearrangement procedure completes, what crate ends up on top of each stack?"
crate_input, instructions = read_file('input.txt')
crates = get_crates(crate_input)
part_two(crates, instructions)