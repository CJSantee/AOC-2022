def read_file(filename)
  f = File.open(filename)
  datastream = f.gets
  chars = datastream.split('')
  f.close
  return chars 
end

def find_unique_substring(chars, substring_length, debug) 
  idx = 0
  found = 0
  while idx < chars.length-substring_length do 
    if (found > 0)
      found = 0
    end
    offset_start = 0
    while offset_start < substring_length-1 do 
      break if found > 0 
      offset_end = 1
      while offset_start + offset_end < substring_length do 
        puts "comparing '#{chars[idx+offset_start]}'[#{idx}+#{offset_start}] to '#{chars[idx+offset_start+offset_end]}'[#{idx}+#{offset_start}+#{offset_end}]#{found > 0 ? '*' : ''}" if debug
        if (chars[idx+offset_start] == chars[idx+offset_start+offset_end])
          puts "'#{chars[idx+offset_start]}' found at idx #{idx+offset_start} and #{idx+offset_start+offset_end}" if debug
          found = idx + offset_start + offset_end
          break
        else
          offset_end += 1
        end
      end
      offset_start += 1
    end
    if (found == 0)
      puts idx + substring_length
      break
    end
    idx += 1
  end
end

# Part One
chars = read_file('input.txt')
debug = false

puts "How many characters need to be processed before the first start-of-packet marker is detected?" 
find_unique_substring(chars, 4, debug)

puts "How many characters need to be processed before the first start-of-message marker is detected?"
find_unique_substring(chars, 14, debug)


# for idx in 0..chars.length-4 do 
#   checking = chars[idx]
#   if (checking == chars[idx+1])
#     puts "'#{checking}' found at idx #{idx} and #{idx+1}" if debug
#     next
#   elsif (checking == chars[idx+2])
#     puts "'#{checking}' found at idx #{idx} and #{idx+2}" if debug 
#     next
#   elsif (checking == chars[idx+3])
#     puts "'#{checking}' found at idx #{idx} and #{idx+3}" if debug
#     next
#   else
#     # check three ahead
#     if (chars[idx+1] == chars[idx+2])
#       puts "'#{chars[idx+1]}' found at idx #{idx+1} and #{idx+2}" if debug
#       next
#     elsif (chars[idx+1] == chars[idx+3])
#       puts "'#{chars[idx+1]}' found at idx #{idx+1} and #{idx+3}" if debug
#       next
#     elsif (chars[idx+2] == chars[idx+3])
#       puts "'#{chars[idx+2]}' found at idx #{idx+2} and #{idx+3}" if debug
#       next
#     else 
#       puts idx + 4
#       break
#     end
#   end
# end
