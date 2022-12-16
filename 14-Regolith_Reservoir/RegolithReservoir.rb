def print_grid(grid)
  for row in 0..grid.length-1 do 
    for col in 0..grid.first.length-1 do 
      print "#{grid[row][col]}"
    end
    print "\n"
  end
  for col in 0..grid.first.length-1 do 
    print "-"
  end
  print "\n"
end

def get_grid_bounds(points)
  min_x, min_y, max_x, max_y = Float::INFINITY,Float::INFINITY,0,0

  points.each do |point|
    if (point[:x] < min_x) 
      min_x = point[:x]
    end
    if (point[:x] > max_x)
      max_x = point[:x]
    end
    if (point[:y] < min_y)
      min_y = point[:y]
    end
    if (point[:y] > max_y)
      max_y = point[:y]
    end
  end

  # Confirm that sand spot (500, 0) is included in grid
  if (500 < min_x) 
    min_x = 500
  end
  if (500 > max_x)
    max_x = 500
  end
  if (0 < min_y)
    min_y = 0
  end
  if (0 > max_y)
    max_y = 0
  end

  bounds = {min_x: min_x, min_y: min_y, max_x: max_x, max_y: max_y}
  return bounds
end

def get_grid(add_floor)
  points = []
  lines = []
  # Read points and lines from file
  f = File.open("input.txt") 
  while line = f.gets do 
    line_points = line.strip.split(' -> ')
    line_points.each do |point|
      x, y = point.split(',').map(&:to_i)
      points.append({x: x, y: y})
    end
    for idx in 0..line_points.length-2
      from_x, from_y = line_points[idx].split(',').map(&:to_i)
      to_x, to_y = line_points[idx+1].split(',').map(&:to_i)
      lines.append({from: {x: from_x, y: from_y}, to: {x: to_x, y: to_y}})
    end
  end
  f.close
  
  # min_x and min_y will serve as offset for the graph
  bounds = get_grid_bounds(points)
  min_x, min_y, max_x, max_y = bounds.values_at(:min_x, :min_y, :max_x, :max_y)

  if (add_floor)
    height = max_y + 2
    max_y = height

    width = max_y * 2
    
    left = 500 - (width.ceil/2) - 5
    right = 500 + (width.ceil/2) + 5
    if (left < min_x)
      min_x = left
    end
    if (right > max_x)
      max_x = right
    end
    bounds = {min_x: min_x, min_y: min_y, max_x: max_x, max_y: max_y}

    # Append floor
    lines.append({from: {x: min_x, y: max_y}, to: {x: max_x, y: max_y}})
  end

  grid = []
  # Create Grid
  for row in min_y..max_y do 
    grid.append([])
    for col in min_x..max_x do 
      grid[row - min_y].append('.')
    end
  end

  # Put lines on the grid
  lines.each do |line|
    from = line[:from]
    to = line[:to]
    if (from[:x] > to[:x])
      # Moving right to left
      for x_idx in (from[:x]-min_x).downto(to[:x]-min_x) do 
        grid[from[:y]-min_y][x_idx] = "#"
      end
    end
    if (from[:x] < to[:x])
      # Moving left to right
      for x_idx in (from[:x]-min_x).upto(to[:x]-min_x) do
        grid[from[:y]-min_y][x_idx] = "#"
      end
    end
    if (from[:y] > to[:y])
      # Moving bottom to top
      for y_idx in (from[:y]-min_y).downto(to[:y]-min_y) do 
        grid[y_idx][from[:x]-min_x] = "#"
      end
    end
    if (from[:y] < to[:y])
      # Moving top to bottom
      for y_idx in (from[:y]-min_y).upto(to[:y]-min_y) do 
        grid[y_idx][from[:x]-min_x] = "#"
      end
    end
  end
  # Mark sand point
  grid[0-min_y][500-min_x] = "+"

  return grid, bounds
end

def within_bounds(next_point, bounds) 
  within_bounds = true
  x, y = next_point.values_at(:x, :y)
  min_x, min_y, max_x, max_y = bounds.values_at(:min_x, :min_y, :max_x, :max_y)
  if (x < min_x || x > max_x || y < min_y || y > max_y)
    within_bounds = false
  end
  return within_bounds
end

def is_solid(grid, bounds, point)
  begin 
    return ['#', 'o'].include?(grid[point[:y]-bounds[:min_y]][point[:x]-bounds[:min_x]])
  rescue 
    print_grid(grid)
    raise "AN ERROR OCCURRED"
  end
end

def update_grid(grid, bounds, point, value)
  grid[point[:y]-bounds[:min_y]][point[:x]-bounds[:min_x]] = value
  # print_grid(grid)
end

def drop_sand(grid, bounds, part_one)
  # Predefined starting point
  sand = {x: 500, y: 0}
  next_point = sand.clone
  sum = 0
  while (part_one ? within_bounds(next_point, bounds) : !is_solid(grid, bounds, sand)) do
    # Check point below
    next_point = {x: next_point[:x], y: next_point[:y]+1} 
    if (is_solid(grid, bounds, next_point)) 
      # Check one step down and to the left
      next_point = {x: next_point[:x]-1, y: next_point[:y]}
      if(is_solid(grid, bounds, next_point))
        # One step down and to the right
        next_point = {x: next_point[:x]+2, y: next_point[:y]}
        if (is_solid(grid, bounds, next_point))
          # Down one step
          next_point = {x: next_point[:x]-1, y: next_point[:y]-1}
          # print "Down one step\n"
          update_grid(grid, bounds, next_point, "o")
          sum += 1
          next_point = sand.clone
        else
          # One step down and to the right
          next
        end
      else
        # One step down and two the left
        next
      end
    end
  end
  return sum
end

# Part One
puts "How many units of sand come to rest before sand starts flowing into the abyss below?"
grid, bounds = get_grid(false)
puts drop_sand(grid, bounds, true)

# Part Two
puts "How many units of sand come to rest?"
grid, bounds = get_grid(true)
puts drop_sand(grid, bounds, false)
