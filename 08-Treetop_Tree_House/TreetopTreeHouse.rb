$debug = {
	low: true,
	mid: true,
	high: false
}

def read_file(filename)
	f = File.open(filename)
	grid = []
	while line = f.gets do
		grid.append(line.strip.split('').map(&:to_i))
	end
	f.close
	return grid
end

def print_grid(grid)
	grid.each do |row|
		print "#{row}\n"
	end
end

def calculate_visible(grid)
	rows, cols = grid.length, grid.first.length
	num_visible = (rows * 2) + (cols * 2) - 4

	for row in 1.upto(rows-2) do 
		for col in 1.upto(cols-2) do 
			visible_north = true
			visible_east = true
			visible_south = true 
			visible_west = true

			# Check North
			for y in (row-1).downto(0) do 
				if (grid[y][col] >= grid[row][col])
					visible_north = false
					break
				end
			end
			
			# Check East
			for x in (col+1).upto(cols-1) do 
				if (grid[row][x] >= grid[row][col])
					visible_east = false
					break
				end
			end

			# Check South
			for y in (row+1).upto(rows-1) do 
				if (grid[y][col] >= grid[row][col])
					visible_south = false
					break
				end	
			end

			# Check West
			for x in (col-1).downto(0) do 
				if (grid[row][x] >= grid[row][col])
					visible_west = false
					break
				end
			end

			if (visible_north || visible_east || visible_south || visible_west) 
				num_visible += 1
			end
		end
	end

	print_grid(visible) if $debug[:high]
	return num_visible
end

def senic_score(grid)
	rows, cols = grid.length, grid.first.length
	score = Array.new(rows) { Array.new(cols, 0) }
	for row in 1.upto(rows-2) do 
		for col in 1.upto(cols-2) do 
			score_north = 0
			score_east = 0
			score_south = 0 
			score_west = 0

			# Check North
			for y in (row-1).downto(0) do 
				score_north += 1
				if (grid[y][col] >= grid[row][col])
					# puts "not visible"
					break
				end
			end
			
			# Check East
			for x in (col+1).upto(cols-1) do 
				score_east += 1
				if (grid[row][x] >= grid[row][col])
					break
				end
			end

			# Check South
			for y in (row+1).upto(rows-1) do 
				score_south += 1 
				if (grid[y][col] >= grid[row][col])
					break
				end	
			end

			# Check West
			for x in (col-1).downto(0) do 
				score_west += 1
				if (grid[row][x] >= grid[row][col])
					break
				end
			end

			score[row][col] = (score_north * score_east * score_south * score_west);
		end
	end

	max_score = 0
	for row in 1.upto(rows-2) do 
		for col in 1.upto(cols-2) do 
			if (score[row][col] > max_score)
				max_score = score[row][col];
			end
		end
	end

	return max_score
end

grid = read_file('input.txt')

# Part One
puts "how many trees are visible from outside the grid?"
puts calculate_visible(grid)

# Part Two
puts "What is the highest scenic score possible for any tree?"
puts senic_score(grid)