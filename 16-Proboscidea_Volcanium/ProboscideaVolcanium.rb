require_relative "../Tools"
include Input

class Valve 
  attr_accessor :name, :flow_rate, :connected_valves, :open
  
  @@fstring = "Valve %s has flow rate=%i; tunnel(s) lead(s) to valve(s) %s"

  def initialize(line)
    name, flow_rate, connected_valves = Input::parse_string(line, @@fstring)
    @name = name
    @flow_rate = flow_rate
    @connected_valves = connected_valves.split(', ')
    @open = false
  end

  def to_s
    plural = @connected_valves.length > 1
    "Valve #{@name} has flow rate=#{flow_rate}; tunnel#{plural ? 's' : ''} lead#{plural ? 's' : ''} to valve#{plural ? 's' : ''} #{@connected_valves.join(', ')}"
  end
end

def get_valves
  valves = []
  f = File.open("input.txt")
  while line = f.gets do 
    valves.append(Valve.new(line))
  end
  f.close
  return valves
end

def recursive(current_valve, all_valves, opened_valves, time_left, pressure_released)
  if (time_left == 0)
    return pressure_released
  end

  # TODO: Track opened valves instead of unopened valves and add the sum of their flow rate to pressure_released every minute
  total_flow_rate = opened_valves.reduce(0) { |sum, valve| sum + valve.flow_rate }

  open_current_valve = 0
  if (!opened_valves.include?(current_valve))
    open_current_valve = recursive(current_valve, all_valves, [*opened_valves, current_valve], time_left-1, pressure_released+total_flow_rate)
  end

  visit_adjacent_valves = all_valves.filter { |v| current_valve.connected_valves.include?(v.name) }.map { |valve| recursive(valve, all_valves, opened_valves, time_left-1, pressure_released+total_flow_rate)}

  [open_current_valve, *visit_adjacent_valves].max
end

def print_grid(grid, valves)
  print "    "
  for col in 0..grid.first.length-1 do 
    print " #{valves[col].name[0]}  "
  end
  print "\n    "
  for col in 0..grid.first.length-1 do 
    print " #{valves[col].name[1]}  "
  end
  print "\n"
  for row in 0..grid.length-1 do 
    print " #{row + 1}: " if row+1 < 10
    print "#{row + 1}: " if row+1 >= 10
    for col in 0..grid.first.length-1 do 
      print "  #{grid[row][col]} " if grid[row][col] < 10
      print " #{grid[row][col]} " if grid[row][col] >= 10 && grid[row][col] < 100
      print "#{grid[row][col]} " if grid[row][col] >= 100
    end
    print "\n"
  end
end

def print_meta(meta, valves)
  print "    "
  for col in 0..meta.first.length-1 do 
    print "#{valves[col].name[0]} "
  end
  print "\n    "
  for col in 0..meta.first.length-1 do 
    print "#{valves[col].name[1]} "
  end
  print "\n"
  for row in 0..meta.length-1 do 
    print " #{row + 1}: " if row+1 < 10
    print "#{row + 1}: " if row+1 >= 10
    for col in 0..meta.first.length-1 do 
      if (meta[row][col][:open] && meta[row][col][:releasing])
        print "1 "
      else
        print "0 "
      end
    end
    print "\n"
  end
end

def dynamic_programming(valves, time)
  # Row = Time
  # Col = Valve
  grid = Array.new(time) { Array.new(valves.length, 0) }
  meta = Array.new(time) { Array.new(valves.length) { Hash.new } }

  # Find "shortest path" to each valve and add time it would take to open
  queue = []
  visited = Hash.new()
  time_to_open = Hash.new()

  start = valves.find { |valve| valve.name == "AA" }
  visited[start.name] = true
  time_to_open[start.name] = 1
  queue.unshift(start)

  while (queue.length != 0) do 
    u = queue.pop
    u.connected_valves.each do |valve_name|
      if (!visited[valve_name])
        visited[valve_name] = true
        time_to_open[valve_name] = time_to_open[u.name] + 1
        queue.unshift(valves.find { |valve| valve.name == valve_name })
      end
    end
  end 

  puts time_to_open

  for row in 0..29 do 
    for col in 0..valves.length-1 do 
      meta[row][col] = {
        open: [],
        releasing: 0
      }
    end
  end

  # Populate grid with initial opening of each valve
  valves.each.with_index do |valve, idx|
    row = time_to_open[valve.name]
    col = idx
    grid[row][col] = valve.flow_rate
    meta[row][col] = {
      open: [valve.name],
      releasing: valve.flow_rate 
    }
  end

  print_grid(grid, valves)
  print "=========\n"
  print_meta(meta, valves)
  
  # DP Algorithm for finding max pressure_released
  for time in 2..30 do 
    for v in 0..valves.length-1 do 
      max = grid[time-1][v]
      # Handle valve is already open but you want to stay
      if ((time > time_to_open[valves[v].name]+1 ? grid[time-2][v]+meta[time-2][v][:releasing]+valves[v].flow_rate : 0) > max)
        if (meta[time-2][v][:open].include?(valves[v].name))
          meta[time-1][v] = {
            open: meta[time-2][v][:open],
            releasing: meta[time-2][v][:releasing]
          }
          max = grid[time-2][v]+meta[time-2][v][:releasing]
        else
          meta[time-1][v] = {
            open: [*meta[time-2][v][:open], valves[v].name],
            releasing: meta[time-2][v][:releasing]+valves[v].flow_rate
          }
          max = grid[time-2][v]+meta[time-2][v][:releasing]+valves[v].flow_rate
        end
      end
      valves[v].connected_valves.each do |valve_name|
        cv = valves.find_index { |v| v.name == valve_name }
        if (grid[time-2][cv]+meta[time-2][cv][:releasing] > max)
          meta[time-1][v] = {
            open: meta[time-2][cv][:open],
            releasing: meta[time-2][cv][:releasing]
          }
          max = grid[time-2][cv]+meta[time-2][cv][:releasing]
        end
      end
      grid[time-1][v] = max
    end
  end
  
  print_grid(grid, valves)

  puts meta[29][9]

  return 0
end

def part_one(valves)
  start = valves.find { |valve| valve.name == "AA" }  
  dynamic_programming(valves, 30)
end

# Part One
puts "What is the most pressure you can release?"
valves = get_valves()

puts part_one(valves)
