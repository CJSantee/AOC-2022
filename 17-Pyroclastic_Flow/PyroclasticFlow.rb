$debug = false
$rocks = [
  {
    name: '-',
    width: 4,
    height: 1,
    pattern: [['#','#','#','#']]
  },
  {
    name: '+',
    width: 3,
    height: 3,
    pattern: [
      ['.','#','.'],
      ['#','#','#'],
      ['.','#','.']
    ],
  },
  {
    name: 'L',
    width: 3,
    height: 3,
    pattern: [
      ['#','#','#'],
      ['.','.','#'],
      ['.','.','#']
    ]
  },
  {
    name: '|',
    width: 1,
    height: 4,
    pattern: [
      ['#'],
      ['#'],
      ['#'],
      ['#']
    ]
  },
  {
    name: '#',
    width: 2,
    height: 2,
    pattern: [
      ['#', '#'],
      ['#', '#']
    ]
  }
]

$chamber = [
  ['-','-','-','-','-','-','-'],
  ['.','.','.','.','.','.','.'],
  ['.','.','.','.','.','.','.'],
  ['.','.','.','.','.','.','.'],
]

def get_jet_pattern
  f = File.open("input.txt")
  jet_pattern = f.gets.split('')
  f.close
  return jet_pattern
end

def print_chamber
  for row in ($chamber.length-1).downto(0) do 
    print row == 0 ? '+ ' : '| '
    for col in 0..$chamber.first.length-1 do 
      print "#{$chamber[row][col]} "
    end
    print row == 0 ? "+\n" : "|\n"
  end
end

def can_move_left(rock, bottom_left)
  if (bottom_left[:col] <= 0)
    return false
  end
  if (rock[:name] == '+')
    # -->.#.
    #    ###
    #    .#.
    if ($chamber[bottom_left[:row]+2] && $chamber[bottom_left[:row]+2][bottom_left[:col]+1] == '#')
      return false
    end

    #    ..#.
    # -->.###
    #    ..#.
    if ($chamber[bottom_left[:row]+1] && $chamber[bottom_left[:row]+1][bottom_left[:col]] == '#')
      return false
    end

    #    .#.
    #    ### 
    # -->.#.
    if ($chamber[bottom_left[:row]] && $chamber[bottom_left[:row]][bottom_left[:col]+1] == '#')
      return false
    end
  elsif (rock[:name] == "L")
    # -->.#
    #   ..#
    #   ###
    if ($chamber[bottom_left[:row]+2] && $chamber[bottom_left[:row]+2][bottom_left[:col]+1] == '#')
      return false
    end

    #   ..#
    # -->.#
    #   ###
    if ($chamber[bottom_left[:row]+1] && $chamber[bottom_left[:row]+1][bottom_left[:col]+1] == '#')
      return false
    end

    #    ...#
    #    ...#
    # -->.###
    if ($chamber[bottom_left[:row]] && $chamber[bottom_left[:row]][bottom_left[:col]-1] == '#')
      return false
    end
  else
    for row_offset in 0..rock[:height]-1 do 
      row = bottom_left[:row]+row_offset
      col = bottom_left[:col]-1
      if ($chamber[row])
        if ($chamber[row][col] == '#') 
          return false
        end
      end
    end
  end
  return true
end

def can_move_right(rock, bottom_left)
  if (bottom_left[:col]+rock[:width] >= 7)
    return false
  end
  if (rock[:name] == '+')
    # ..#.<--
    # .###
    # ..#.
    if ($chamber[bottom_left[:row]+2] && $chamber[bottom_left[:row]+2][bottom_left[:col]+2] == '#')
      return false
    end

    # ..#. 
    # .###.<--
    # ..#.
    if ($chamber[bottom_left[:row]+1] && $chamber[bottom_left[:row]+1][bottom_left[:col]+3] == '#')
      return false
    end

    # ..#. 
    # .###
    # ..#.<--
    if ($chamber[bottom_left[:row]] && $chamber[bottom_left[:row]][bottom_left[:col]+2] == '#')
      return false
    end
  else
    for row_offset in 0..rock[:height]-1 do 
      row = bottom_left[:row]+row_offset
      col = bottom_left[:col]+rock[:width]
      if ($chamber[row])
        if ($chamber[row][col] == '#') 
          return false
        end
      end
    end
  end
  return true
end

def can_move_down(rock, bottom_left)
  if (rock[:name] == '+')
    # .#.
    # ###
    # .#.
    # ^
    if ($chamber[bottom_left[:row]] && $chamber[bottom_left[:row]][bottom_left[:col]] == '#')
      return false
    end

    # .#.
    # ###
    # .#.
    # ...
    #  ^
    if ($chamber[bottom_left[:row]-1] && $chamber[bottom_left[:row]-1][bottom_left[:col]+1] == '#')
      return false
    end

    # .#.
    # ###
    # .#.
    #   ^
    if ($chamber[bottom_left[:row]] && $chamber[bottom_left[:row]][bottom_left[:col]+2] == '#')
      return false
    end

    return true
  else
    row = bottom_left[:row] - 1
    for col_offset in 0..rock[:width]-1 do 
      col = bottom_left[:col] + col_offset
      if (['-', '#'].include?($chamber[row][col]))
        return false
      end
    end
    return true
  end
end

def part_one
  jet_pattern = get_jet_pattern()

  print_chamber() if $debug
  
  number_of_rocks = 2022
  rock_idx = 0
  jet_idx = 0

  # Solution to the problem: tower_height
  tower_height = 0

  # Droping rock 
  for rock_num in 1..number_of_rocks do 
    # Drop Rock
    rock = $rocks[rock_idx % $rocks.length]
    rock_idx += 1
    bottom_left = {row: $chamber.length, col: 2}

    # Keep track of the amount below the previous tower height the current rock falls
    drop_amount = 0

    puts "A new rock begins falling" if $debug
    while (true) do 
      jet = jet_pattern[jet_idx % jet_pattern.length]
      jet_idx += 1
      if (jet == '>')
        can_move_right = true
        # Move Rock Right 
        if (can_move_right(rock, bottom_left))
          bottom_left[:col] += 1
          puts "Jet of gas pushes rock right" if $debug
        else
          puts "Jet of gas pushes rock right, but nothing happens" if $debug
        end
      else
        # Move Rock Left
        if (can_move_left(rock, bottom_left))
          bottom_left[:col] -= 1
          puts "Jet of gas pushes rock left" if $debug
        else
          puts "Jet of gas pushes rock left, but nothing happens" if $debug
        end
      end

      if (can_move_down(rock, bottom_left))
        bottom_left[:row] -= 1
        drop_amount += 1
        puts "Rock falls 1 unit" if $debug
      else
        puts "Rock falls 1 unit, causing it to come to rest" if $debug
        break
      end
    end

    # Chamber coords for rock
    c_row = bottom_left[:row]
    c_col = bottom_left[:col]

    # Modify chamber
    for r_row in 0..rock[:pattern].length-1 do 
      $chamber.append(['.','.','.','.','.','.','.']) if c_row+r_row >= $chamber.length
      for r_col in 0..rock[:pattern].first.length-1 do 
        $chamber[c_row+r_row][c_col+r_col] = rock[:pattern][r_row][r_col]
      end
    end

    height_added = rock[:height] - (drop_amount - 3)
    tower_height += (height_added > 0 ? height_added : 0)
    height_added.times { $chamber.append(['.','.','.','.','.','.','.']) }
    
    print_chamber() if $debug
  end

  return tower_height
end

# Part One
puts "How many units tall will the tower of rocks be after 2022 rocks have stopped falling?"
puts part_one()
