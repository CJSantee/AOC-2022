require 'set'
$debug = false

class Queue 
	attr_accessor :items
	def initialize(items)
		@items=items
	end
	def enqueue(item)
		@items.unshift(item)
	end
	def dequeue
		@items.pop
	end
	def empty
		@items.length == 0
	end
end

class Node 
	attr_accessor :row, :col, :height
	def initialize(row, col, height)
		@row=row
		@col=col
		@height=height
	end

	def coords
		{row: @row, col: @col}
	end
end

class Graph 
	attr_accessor :nodes, :edges
	def initialize(nodes, edges, start, finish)
		@nodes=nodes
		@edges=edges
		@start=start
		@finish=finish
	end

	def min_distance(dist, path)
		min = Float::INFINITY
		min_coords = Hash.new()
		dist.keys.each do |coords|
			if (path[coords] == false && dist[coords] <= min)
				min = dist[coords]
				min_coords = coords
			end
		end
		return min_coords
	end

	def print_graph
		@nodes.each do |row|
			row.each do |col|
				if col.height < 10 
					print "0#{col.height} "
				else
					print "#{col.height} "
				end
			end
			print "\n"
		end

		@edges.keys.each do |key|
			puts key
			@edges[key].each do |node|
				puts "[#{node.row}][#{node.col}] (#{node.height})"
			end
		end
	end

	def dijkstra(start)
		puts "Running Didjstra's algorithm..." if $debug
		# Initialize distances and unvisited lists (hash/set)
		distances = Hash.new()
		path = Hash.new()

		for row in 0..@nodes.length-1 do
			for col in 0..@nodes.first.length-1 do 
				distances[{row: row, col: col}] = Float::INFINITY
				path[{row: row, col: col}] = false
			end
		end

		distances[start] = 0
		
		for count in 0..distances.size-1 do 
			coords = min_distance(distances, path)
			path[coords] = true
			@edges[coords].each do |node|
				if (!path[node.coords] && distances[coords] + 1 < distances[node.coords]) 
					distances[node.coords] = distances[coords] + 1
				end
			end
		end
		puts "Dijkstra's algorithm completed!" if $debug
		return distances
	end

	def shortest_path
		distances = dijkstra(@start)
		return distances[@finish]
	end

	def breadth_first_search(start, finish)
		puts "Running breadth first search..." if $debug

		queue = Queue.new([])
		visited = Hash.new()
		dist = Hash.new()
		pred = Hash.new() 

		for row in 0..@nodes.length-1 do 
			for col in 0..@nodes.first.length-1 do 
				visited[{row: row, col: col}] = false
				dist[{row: row, col: col}] = Float::INFINITY
				pred[{row: row, col: col}] = -1
			end
		end

		visited[start] = true
		dist[start] = 0
		queue.enqueue(start)

		while (!queue.empty)
			u = queue.dequeue
			if (u == finish)
				puts "found! #{dist[u]}" if $debug
				return dist[u]
			end
			@edges[u].each do |node|
				if (!visited[node.coords])
					visited[node.coords] = true
					dist[node.coords] = dist[u] + 1
					pred[node.coords] = u
					queue.enqueue(node.coords)
					
				end
			end
		end
	end

	def part_one
		breadth_first_search(@start, @finish)
	end

	def part_two
		a_coords = []
		for row in 0..@nodes.length-1 do 
			for col in 0..@nodes.first.length-1 do 
				if (@nodes[row][col].height == 1)
					a_coords.append({row: row, col: col})
				end
			end
		end

		min = Float::INFINITY
		a_coords.each do |coords|
			dist = breadth_first_search(coords, @finish)
			if (!dist)
				next
			end
			if (dist < min)
				min = dist
			end
		end
		return min
	end

end

def read_file(filename)
	f = File.open(filename)
	grid = []
	start = Hash.new()
	finish = Hash.new()

	# Create Grid from File
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

	# Create Notes
	rows = grid.length
	cols = grid.first.length
	graph = Graph.new([], Hash.new(), start, finish)
	for row in 0..rows-1 do 
		graph.nodes.append([])
		for col in 0..cols-1 do 
			graph.nodes[row].append(Node.new(row, col, grid[row][col]))
			graph.edges[{row: row, col: col}] = []
		end
	end

	# Create Edges
	for row in 0..rows-1 do 
		for col in 0..cols-1 do 
			# Top
			if (row > 0)
				if (grid[row-1][col] <= grid[row][col] + 1)
					graph.edges[{row: row, col: col}].append(graph.nodes[row-1][col])
				end
			end
			# Right
			if (col < cols-1)
				if (grid[row][col+1] <= grid[row][col] + 1)
					graph.edges[{row: row, col: col}].append(graph.nodes[row][col+1])
				end
			end
			# Down
			if (row < rows-1)
				if (grid[row+1][col] <= grid[row][col] + 1)
					graph.edges[{row: row, col: col}].append(graph.nodes[row+1][col])
				end
			end
			# Left
			if (col > 0)
				if (grid[row][col-1] <= grid[row][col] + 1)
					graph.edges[{row: row, col: col}].append(graph.nodes[row][col-1])
				end
			end
		end
	end

	return graph
end

def print_grid(grid)
	grid.each do |row|
		print "#{row}\n"
	end
end

graph = read_file("input.txt")

# Part One
puts "What is the fewest steps required to move from your current position to the location that should get the best signal?"
puts graph.part_one

# Part Two
puts "What is the fewest steps required to move starting from any square with elevation a to the location that should get the best signal?"
puts graph.part_two