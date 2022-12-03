# Part One
puts "Find the item type that appears in both compartments of each rucksack. What is the sum of the priorities of those item types?"

f = File.open('input.txt')

def charPriority (character) 
	val = character.ord
	if (val >= 97)
		val -= 96
	else
		val -= 38
	end	
	return val
end

total_priority = 0
while line = f.gets do 
	first, second = line[0...line.length/2], line[line.length/2...line.length] 
	freqFirst = Array.new(52, 0)
	freqSecond = Array.new(52, 0)

	first.split('').each do |char| 
		freqFirst[charPriority(char)-1] += 1
	end

	second.split('').each do |char|
		freqSecond[charPriority(char)-1] += 1
	end

	for idx in 0..51 do 
		if (freqFirst[idx] > 0 && freqSecond[idx] > 0)
			total_priority += idx + 1
		end
	end
end

puts total_priority
f.close

# Part Two
puts "Find the item type that corresponds to the badges of each three-Elf group. What is the sum of the priorities of those item types?"
f = File.open('input.txt')

def findBadge(group)
	# puts group 

	frequencies = Array.new(3) {Array.new(52, 0)}

	group.each.with_index do |rucksack, idx|
		rucksack.split('').each do |char| 
			if (charPriority(char) >= 0)
				frequencies[idx][charPriority(char)-1] += 1 
			end	
		end
	end

	# frequencies.each.with_index do |freq, idx|
	# 	puts "#{idx}: #{freq}\n"
	# end
	
	for idx in 0..51 do 
		if(frequencies[0][idx] > 0 && frequencies[1][idx] > 0 && frequencies[2][idx] > 0) 
			return idx + 1
		end
	end
end

total_priority = 0
group = []
while line = f.gets do 
	if (group.length < 3)
		group.append(line)
	end
	if (group.length == 3)
		badge = findBadge(group)
		total_priority += badge
		group = []
	end
end

puts total_priority
