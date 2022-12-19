module Input 
  class << self
    ##
    # Returns integers from string definded in positions where '%i' is in the fstring
    def parse_string(string, fstring)
      # Generate regex from fstring
      regex = fstring.gsub('%i', '([\d-]*)').gsub('%s', '(.*)')
      fstring.split(/%i|%s/).map do |section| 
        {
          replace: section, 
          with: "(?:#{section =~ /(\(.+?\))/ ? section.gsub(/(\(.+?\))/) { |s| "(?:#{s.gsub!(/\(|\)/, '')}|)"} : section})"
        } 
      end.each do |rw|
        regex.gsub!(rw[:replace], rw[:with])
      end
      # Get values from string using regex
      values = /#{regex}/.match(string)&.captures
      # Scans operators for %i to map to integer
      fstring.scan(/%[a-z]/).each.with_index do |operator, idx|        
        values[idx] = values[idx].to_i if (operator == '%i')
      end
      return values
    end
  end
end

module Grid
  class << self
    ##
    # Returns the manhattan distance (taxicab distance) between two points, p {Hash}, and q {Hash}
    def manhattan_distance(p, q)
      (p[:x] - q[:x]).abs + (p[:y]-q[:y]).abs
    end

    ##
    # Returns {:min_x, :min_y, :max_x, :max_y} for a set of points {Hash}
    def get_bounds(points)
      min_x, min_y, max_x, max_y = Float::INFINITY, Float::INFINITY, 0, 0
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
      {min_x: min_x, min_y: min_y, max_x: max_x, max_y: max_y}
    end 

    ##
    # Returns a 2d-list of size (bounds[:max_y]-bounds[:min_y]) x (bounds[:max_x][:min_x]) with values initialized to initial_value
    def grid_from_bounds(bounds, initial_value)
      Array.new((bounds[:max_y] - bounds[:min_y]) + 1) { Array.new((bounds[:max_x] - bounds[:min_x]) + 1, initial_value) }
    end

    ##
    # Assigns a value to a point in the grid
    def assign_point(grid, bounds, point, value)
      grid[point[:y]-bounds[:min_y]][point[:x]-bounds[:min_x]] = value
    end
  end
end
