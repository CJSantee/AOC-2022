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

def recursive(current_valve, unopened_valves, time_left, pressure_released)
  if (time_left == 0)
    return pressure_released
  end

  # TODO: Track opened valves instead of unopened valves and add the sum of their flow rate to pressure_released every minute

  open_current_valve = recursive(current_valve, unopened_valves.filter {|v| v != current_valve}, time_left-1, pressure_released+current_valve.flow_rate)
  visit_adjacent_valves = unopened_valves.filter { |v| current_valve.connected_valves.include?(v.name) }.map { |valve| recursive(valve, unopened_valves.filter { |v| v != valve }, time_left-1, pressure_released)}

  [open_current_valve, *visit_adjacent_valves].max
end

def part_one(valves)
  start = valves.find { |valve| valve.name == "AA" }  
  return recursive(start, valves.filter { |valve| valve != start }, 30, 0)
end

# Part One
puts "What is the most pressure you can release?"
valves = get_valves()

puts part_one(valves)
