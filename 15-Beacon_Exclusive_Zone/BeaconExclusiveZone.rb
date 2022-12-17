require 'set'
require_relative "../Tools"
include Input
include Grid

class Sensor 
  attr_accessor :point, :closest_beacon
  
  @@fstring = "Sensor at x=%i, y=%i: closest beacon is at x=%i, y=%i"

  def initialize(line)
    sensor_x, sensor_y, beacon_x, beacon_y = Input::parse_string(line, @@fstring)
    @point = {x: sensor_x, y: sensor_y}
    @closest_beacon = {x: beacon_x, y: beacon_y}
  end

  def manhattan_distance
    Grid.manhattan_distance(@point, @closest_beacon)
  end

  def to_s
    "Sensor at x=#{@point[:x]}, y=#{@point[:y]}: closest beacon is at x=#{@closest_beacon[:x]}, y=#{@closest_beacon[:y]}"
  end
end

def read_sensors
  sensors = []
  f = File.open("input.txt")
  while line = f.gets do 
    sensors.append(Sensor.new(line))
  end
  f.close
  return sensors
end

def get_bounds(sensors)
  min_x, min_y, max_x, max_y = 0, 0, 0, 0

  sensor_bounds = Grid.get_bounds(sensors.map {|sensor| sensor.point})
  beacon_bounds = Grid.get_bounds(sensors.map {|sensor| sensor.closest_beacon})

  min_x = [sensor_bounds[:min_x], beacon_bounds[:min_x]].min
  min_y = [sensor_bounds[:min_y], beacon_bounds[:min_y]].min
  max_x = [sensor_bounds[:max_x], beacon_bounds[:max_x]].max
  max_y = [sensor_bounds[:max_y], beacon_bounds[:max_y]].max

  {min_x: min_x, min_y: min_y, max_x: max_x, max_y: max_y}
end

def print_grid(grid, bounds)
  print "   "
  for col in bounds[:min_x]..bounds[:max_x] do 
    if (col >= 10 && col % 5 == 0)
      print col / 10 
    else
      print " "
    end
  end
  print "\n"
  print "   "
  for col in bounds[:min_x]..bounds[:max_x] do 
    if (col % 5 == 0)
      print col % 10 
    else
      print " "
    end
  end
  print "\n"

  for row in 0..grid.length-1 do 
    print " #{row} " if row < 10
    print "#{row} " if row >= 10
    for col in 0..grid.first.length-1 do 
      print grid[row][col]
    end
    print "\n"
  end
end

def populate_grid(grid, bounds, sensors)
  sensors.each do |sensor|
    Grid.assign_point(grid, bounds, sensor.point, "S")
    Grid.assign_point(grid, bounds, sensor.closest_beacon, "B")
  end
end

def part_one(sensors, check_row)
  bounds = get_bounds(sensors)

  filtered_sensors = []
  sensors.each do |sensor|
    md = Grid.manhattan_distance(sensor.point, sensor.closest_beacon)
    if (sensor.point[:y] - md < check_row && sensor.point[:y] + md > check_row)
      filtered_sensors.append(sensor)
    end
  end
  
  available_positions = Set[]
  occupied_positions = Set[]
  filtered_sensors.each do |sensor|
    point = sensor.point
    if (point[:y] == check_row)
      occupied_positions[{x: point[:x], y: check_row}] = true
    end
    beacon = sensor.closest_beacon
    if (beacon[:y] == check_row)
      occupied_positions.add({x: beacon[:x], y: check_row})
    end
    manhattan_distance = sensor.manhattan_distance
    horizontal_distance = manhattan_distance - (check_row - point[:y]).abs
    for x_idx in point[:x]-horizontal_distance..point[:x]+horizontal_distance do 
      available_positions.add({x: x_idx, y: check_row})
    end
  end
  available_positions.size - occupied_positions.size
end

def tuning_frequency(point)
  (point[:x]*4000000)+point[:y]
end

def outside_searchspace(point, max)
  point[:x] > max || point[:x] < 0 || point[:y] > max || point[:y] < 0
end

def within_range(point, sensors)
  sensors.each do |sensor|
    manhattan_distance = Grid.manhattan_distance(sensor.point, sensor.closest_beacon)
    if (Grid.manhattan_distance(sensor.point, point) <= manhattan_distance)
      return true
    end
  end
  return false
end

def find_distress_signal(sensors)
  sensors.each do |sensor|
    point = sensor.point
    beacon = sensor.closest_beacon
    manhattan_distance = Grid.manhattan_distance(point, beacon)
    start = {x: point[:x], y: point[:y]-manhattan_distance-1}
    for offset in 0..manhattan_distance+1 do 
      # Down the top right edge of diamond perimiter
      check = {x: start[:x]+offset, y: start[:y]+offset}
      if (outside_searchspace(check, 4000000))
        next
      end
      if (!within_range(check, sensors))
        return check
      end
    end
    start = check
    for offset in 0..manhattan_distance+1 do 
      # Down the bottom right edge of diamond perimiter
      check = {x: start[:x]-offset, y: start[:y]+offset}
      if (outside_searchspace(check, 4000000))
        next
      end
      if (!within_range(check, sensors))
        return check
      end
    end
    start = check
    for offset in 0..manhattan_distance+1 do 
      # Up the bottom left edge of diamond perimiter
      check = {x: start[:x]-offset, y: start[:y]-offset}
      if (outside_searchspace(check, 4000000))
        next
      end
      if (!within_range(check, sensors))
        return check
      end
    end
    start = check
    for offset in 0..manhattan_distance do 
      # Up the top left edge of diamond perimiter
      check = {x: start[:x]+offset, y: start[:y]-offset}
      if (outside_searchspace(check, 4000000))
        next
      end
      if (!within_range(check, sensors))
        return check
      end
    end
  end 
end

# walk along the edge of the diamonds created by the sensors and for every of these positions, check if it is within range of any of the sensors. If not, we have found the result
def part_two(sensors)
  point = find_distress_signal(sensors)
  tuning_frequency(point)
end

# Part One
puts "In the row where y=2000000, how many positions cannot contain a beacon?"
sensors = read_sensors()
puts part_one(sensors, 2000000)

# Part Two 
puts "What is its tuning frequency"
puts part_two(sensors)