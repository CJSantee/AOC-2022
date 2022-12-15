$debug = false

class Pair
	attr_accessor :left, :right
	def initialize(left, right)
		@left=left
		@right=right
	end

	def to_s
		"#{left}\n#{right}\n"
	end
end

def to_list(list, idx)
	list.slice(0, idx).append([list[idx]]).concat(list.slice(idx+1, list.length-1))
end

def compare(left, right, idx, depth)
	# Index out-of-bounds
	if (idx == left.length && idx < right.length)
		# Left ran out of items first, the inputs are in the right order
		print "  "*depth if $debug
		print "- Left side ran out of items, so inputs are in the right order\n" if $debug
		return true
	end
	if (idx == right.length && idx < left.length)
		# Right ran out of items first, the inputs are not in the right order
		print "  "*depth if $debug
		print "- Right side ran out of items, so inputs are not in the right order\n" if $debug
		return false
	end
	if (idx == left.length && idx == right.length)
		# If the lists are the same length and no comparison makes a decision about the order,
		# continue checking the next part of the input
		return nil
	end	

	print "  "*depth if $debug
	print "- Compare #{left[idx]} vs #{right[idx]}\n" if $debug

	# Both lists, recurse
	if (left[idx].class.to_s == "Array" && right[idx].class.to_s == "Array")
		subproblem = compare(left[idx], right[idx], 0, depth+1)
		if (subproblem == nil)
			return compare(left, right, idx+1, depth)
		else
			return subproblem
		end
	end

	# One list, one integer
	if (left[idx].class.to_s == "Array" && right[idx].class.to_s == "Integer")
		print "  "*depth if $debug
		print "- Mixed types; convert right to #{[right[idx]]} and retry comparison\n" if $debug
		return compare(left, to_list(right, idx), idx, depth)
	elsif (left[idx].class.to_s == "Integer" && right[idx].class.to_s == "Array")
		print "  "*depth if $debug
		print "- Mixed types; convert left to #{[left[idx]]} and retry comparison\n" if $debug
		return compare(to_list(left, idx), right, idx, depth)
	end

	# Compare values of left and right
	if (left[idx] < right[idx])
		print "  "*depth if $debug
		print "  - Left side is smaller, so inputs are in the right order\n" if $debug
		return true
	elsif (left[idx] > right[idx])
		print "  "*depth if $debug
		print " - Right side is smaller, so inputs are not in the right order\n" if $debug
		return false
	else
		return compare(left, right, idx+1, depth)
	end
end

def get_pairs(filename)
	pairs = []
	f = File.open(filename)
	left = nil
	right = nil
	while line = f.gets do 
		if (left == nil)
			left = eval(line.strip)
		elsif (right == nil)
			right = eval(line.strip)
		else
			pairs.append(Pair.new(left, right))
			left = nil
			right = nil 
		end
	end
	pairs.append(Pair.new(left, right)) # Don't forget the last pair!
	f.close
	return pairs
end

def get_packets(filename)
	f = File.open(filename)
	packets = []
	while line = f.gets do 
		if (line != "\n")
			packets.append(eval(line.strip))
		end
	end
	f.close
	return packets 
end

def print_packets(packets)
	packets.each.with_index do |packet, idx|
	print "#{packet}\n"
end
end

def swap(arr, xp, yp)
	temp = arr[xp]
	arr[xp] = arr[yp]
	arr[yp] = temp
end

def bubble_sort(packets)
	n = packets.length
	for i in 0..n-2 do 
		for j in 0..n-i-2 do 
			left = packets[j]
			right = packets[j+1]
			if (compare(left, right, 0, 0) == false)
				swap(packets, j, j+1)
			end
		end
	end
end

# Part One
puts "What is the sum of the indices of those pairs?"
pairs = get_pairs("input.txt")

sum = 0
pairs.each.with_index do |pair, idx|
	puts "== Pair #{idx+1} ==" if $debug
	print "- Compare #{pair.left} vs #{pair.right}\n" if $debug
	result = compare(pair.left, pair.right, 0, 1)
	if (result)
		sum += idx+1
	end
	print "\n" if $debug
end

puts sum

puts "What is the decoder key for the distress signal?"
packets = get_packets("input.txt")
first = [[2]]
second = [[6]]
packets.append(first)
packets.append(second)

bubble_sort(packets)

first_idx = packets.find_index(first)+1
second_idx = packets.find_index(second)+1

puts first_idx * second_idx

