require 'set'
require_relative "../Tools"
include Input

class Valve 
  attr_accessor :name, :flow_rate, :connected_valves
  
  @@fstring = "Valve %s has flow rate=%i; tunnel(s) lead(s) to valve(s) %s"

  def initialize(line)
    name, flow_rate, connected_valves = Input::parse_string(line, @@fstring)
    @name = name
    @flow_rate = flow_rate
    @connected_valves = connected_valves.split(', ')
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

$bfs_memo = Hash.new()
def bfs_shortest_path(valves, start, finish)
  if ($bfs_memo[{start: start, finish: finish}])
    return $bfs_memo[{start: start, finish: finish}]
  end

  queue = []
  visited = Hash.new()
  dist = Hash.new()

  valves.each do |valve|
    visited[valve.name] = false
    dist[valve.name] = Float::INFINITY
  end

  visited[start] = true
  dist[start] = 0
  queue.unshift(start)

  while (queue.length != 0) do 
    u = queue.pop
    if (u == finish)
      $bfs_memo[{start: start, finish: finish}] = dist[u]
      return dist[u]
    end
    valves.find { |valve| valve.name == u }.connected_valves.each do |cv|
      if (!visited[cv]) 
        visited[cv] = true
        dist[cv] = dist[u] + 1
        queue.unshift(cv)
      end
    end
  end
end

def part_one(valves)
  useful_valves = valves.filter { |v| v.flow_rate != 0 }

  start = valves.find { |valve| valve.name == "AA" }  
  time_limit = 30
  max_pressure_released = 0
  max_path = []

  # a stack of our current branches - [path], minutes_elapsed, { valve: <minute opened> }
  stack = [[[start], 0, Hash.new]]

  while (stack.size > 0) do 
    path, time, opened_valves = stack.pop
    current_valve = path.last
    
    # Time has reached 30 minutes or path includes all useful_valves and AA
    if (time > time_limit || path.length == useful_valves.length + 1)
    pressure_released = 0

    opened_valves.each do |valve_name, minute_opened|
      minutes_opened = [time_limit - minute_opened, 0].max
      pressure_released += valves.find { |v| v.name == valve_name}.flow_rate * minutes_opened
    end

    if (pressure_released > max_pressure_released)
      max_pressure_released = pressure_released
      max_path = path.map { |v| v.name }
    end
    else
      useful_valves.each do |next_valve|
        if (!opened_valves[next_valve.name])
          travel_time = bfs_shortest_path(valves, current_valve.name, next_valve.name)

          time_to_open = 1

          new_time = time + travel_time + time_to_open

          new_opened_valves = opened_valves.clone
          new_opened_valves[next_valve.name] = new_time

          new_path = path.clone
          new_path.append(next_valve)

          stack.append([new_path, new_time, new_opened_valves])
        end
      end
    end
  end

  puts max_path
  return max_pressure_released
end

def part_two

end

# Part One
puts "What is the most pressure you can release?"
valves = get_valves()

puts part_one(valves)
