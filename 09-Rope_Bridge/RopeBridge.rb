require 'set'

$debug = false

def read_file(filename)
	f = File.open(filename)
	instructions = []
	while line = f.gets do 
		direction, distance = line.split(' ')
		instruction = {
			direction: direction,
			distance: distance.to_i
		}
		instructions.append(instruction)
	end
	f.close
	return instructions
end

# Get New Tail Coords 
def tail_coords(head, tail)
	# Top Left
	if ( (head[:row] == tail[:row]+1 && head[:col] == tail[:col]-2) || (head[:row] == tail[:row]+2 && head[:col] == tail[:col]-1) || (head[:row] == tail[:row]+2 && head[:col] == tail[:col]-2))
		return {row: tail[:row]+1, col: tail[:col]-1}
	# Top Right
	elsif ((head[:row] == tail[:row]+2 && head[:col] == tail[:col]+1) || (head[:row] == tail[:row]+1 && head[:col] == tail[:col]+2) || (head[:row] == tail[:row]+2 && head[:col] == tail[:col]+2))
		return {row: tail[:row]+1, col: tail[:col]+1}
	# Bottom Left
	elsif ((head[:row] == tail[:row]-1 && head[:col] == tail[:col]-2) || (head[:row] == tail[:row]-2 && head[:col] == tail[:col]-1) || (head[:row] == tail[:row]-2 && head[:col] == tail[:col]-2))
		return {row: tail[:row]-1, col: tail[:col]-1}
	# Bottom Right
	elsif ((head[:row] == tail[:row]-2 && head[:col] == tail[:col]+1) || (head[:row] == tail[:row]-1 && head[:col] == tail[:col]+2) || (head[:row] == tail[:row]-2 && head[:col] == tail[:col]+2))
		return {row: tail[:row]-1, col: tail[:col]+1}
	# Top Center
	elsif (head[:row] == tail[:row]+2 && head[:col] == tail[:col])
		return {row: tail[:row]+1, col: tail[:col]}
	# Bottom Center
	elsif (head[:row] == tail[:row]-2 && head[:col] == tail[:col])
		return {row: tail[:row]-1, col: tail[:col]}
	# Left Center
	elsif (head[:row] == tail[:row] && head[:col] == tail[:col]-2)
		return {row: tail[:row], col: tail[:col]-1}
	# Right Center
	elsif (head[:row] == tail[:row] && head[:col] == tail[:col]+2)
		return {row: tail[:row], col: tail[:col]+1}
	else
		return tail
	end
end

# Get New Head Coords
def head_coords(head, direction)
	row, col = head.values_at(:row, :col)
	# Right
	if (direction == "R")
		return {row: row, col: col+1}
	end
	# Left
	if (direction == "L")
		return {row: row, col: col-1}
	end
	# Up
	if (direction == "U")
		return {row: row+1, col: col}
	end
	# Down
	if (direction == "D")
		return {row: row-1, col: col}
	end
end

def part_one(instructions)
	head = {row: 0, col: 0}
	tail = {row: 0, col: 0}
	tail_locations = Set[tail]
	instructions.each do |instruction|
		direction, distance = instruction[:direction], instruction[:distance]
		distance.times do 
			puts "moving HEAD (#{direction}):" if $debug
			puts "from: #{head}" if $debug
			head = head_coords(head, direction)
			puts "to: #{head}" if $debug
			puts "moving TAIL:" if $debug
			puts "from: #{tail}" if $debug
			tail = tail_coords(head, tail)
			puts "to #{tail}" if $debug
			tail_locations.add(tail)
		end
	end
	puts tail_locations.size
end

def print_rope(rope)
	height = 20
	width = 20

	for row in (20).downto(0) do 
		for col in (0).upto(20) do 
			if (rope[0] == {row: row, col: col})
				print "H"
			elsif (rope.include?({row: row, col: col}))
				print rope.find_index({row: row, col: col})
			else
				print "."
			end
		end
		print "\n"
	end
end

def part_two(instructions)
	rope = Array.new(10) {{row: 0, col: 0}}
	tail_locations = Set[rope[9]]
	instructions.each do |instruction|
		direction, distance = instruction[:direction], instruction[:distance]
		distance.times do 
			puts "moving HEAD #{direction}" if $debug
			print "[#{rope[0][:row]}][#{rope[0][:col]}] -> " if $debug
			rope[0] = head_coords(rope[0], direction)
			print "[#{rope[0][:row]}][#{rope[0][:col]}]\n" if $debug
			for idx in 1..9 do 
				puts "moving KNOT ##{idx}" if $debug
				print "[#{rope[idx][:row]}][#{rope[idx][:col]}] -> " if $debug
				rope[idx] = tail_coords(rope[idx-1], rope[idx])
				print "[#{rope[idx][:row]}][#{rope[idx][:col]}]\n" if $debug
			end
			tail_locations.add(rope[9])
			puts "-----" if $debug
			print_rope(rope) if $debug
			puts "-----" if $debug
		end
	end
	print_rope(rope) if $debug
	puts tail_locations.size
end

instructions = read_file("input.txt")

# Part One
puts "How many positions does the tail of the rope visit at least once?"
part_one(instructions)

# Part Two 
puts "How many positions does the tail of the rope visit at least once?"
part_two(instructions)