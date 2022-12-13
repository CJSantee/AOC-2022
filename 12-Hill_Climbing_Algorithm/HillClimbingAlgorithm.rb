# S = -14, E = -28
def read_file(filename)
	f = File.open(filename)
	grid = []
	start = Hash.new()
	finish = Hash.new()

	row_idx = 0
	while line = f.gets do 
		row = line.strip.split('').map { |char| char.ord - 96 }
		if idx = row.index(-13)
			row[idx] = 1
			start[:row] = row_idx
			start[:col] = idx
		end
		if idx = row.index(-27)
			row[idx] = 26
			finish[:row] = row_idx
			finish[:col] = idx
		end
		grid.append(row)
		row_idx += 1
	end
	f.close
	return grid, start, finish
end

def print_grid(grid)
	grid.each do |row|
		print "#{row}\n"
	end
end

# Part One
puts "What is the fewest steps required to move from your current position to the location that should get the best signal?"
grid, start, finish = read_file("input.txt")

puts finish
print_grid(grid)