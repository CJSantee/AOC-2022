$debug = false

class ElfFileSystem
	attr_accessor :root, :disk_space

	def initialize(root, disk_space)
		@root = root
		@disk_space = disk_space
	end

	def available_space
		@disk_space - @root.size
	end

	def part_two(space_required)
		min_remove = space_required - available_space
		puts "required size: #{min_remove}" if $debug
		root.part_two(min_remove, @disk_space)
	end
end

class ElfDirectory
	attr_accessor :name, :elements, :parent

	def initialize name, parent
		@name = name
		@parent = parent
		@elements = []
	end

	def append(element)
		@elements.append(element)
	end

	def part_one(size_limit)
		if (@elements.length == 0)
			0
		else
			@elements.reduce(0) do |sum, element|
				puts "Checking #{element.name} (#{element.size})" if $debug
				if (element.class.to_s == 'ElfDirectory')
					if (element.size <= size_limit)
						puts "Adding #{element.name} (#{element.size})" if $debug
						sum += element.size + element.part_one(size_limit)
					else
						sum += element.part_one(size_limit)
					end
				else
					sum
				end
			end
		end
	end

	def part_two(min_size, min_dir)
		size = self.size
		puts "Checking #{@name} (#{size}), current min: #{min_dir}" if $debug
		if (size > min_size)
			if (size < min_dir)
				@elements.reduce(size) do |min, element|
					min_elm = element.part_two(min_size, size)
					if (min_elm < min)
						min_elm
					else
						min
					end
				end
			else
				puts "#{@name} is not smaller than #{min_dir}, skip check" if $debug
				min_dir
			end
		else
			puts "#{@name} is smaller than required size, skip check" if $debug
			min_dir
		end
	end

	def size
		if (@elements.length == 0)
			0
		else 
			@elements.reduce(0) { |sum, element| sum + element.size }
		end
	end

	def get_directory(name)
		if (name == "..")
			@parent
		else
			@elements.find { |element| element.name == name && element.class.to_s == 'ElfDirectory'}
		end
	end

	def print 
		subprint(0)
	end

	def subprint(subdirectory)
		str = "  "*subdirectory
		str += "- #{@name} (dir)\n"
		if @elements.length
			str += @elements.map { |element| element.subprint(subdirectory+1) }.join()
		end
	end
end

class ElfFile
	attr_accessor :name, :size 

	def initialize name, size
		@name = name
		@size = size
	end

	def print 
		subprint(0)
	end

	def part_two(min_size, min_dir)
		puts "#{@name} is a file, skip check" if $debug
		min_dir
	end

	def subprint(subdirectory)
		str = "  "*subdirectory
		str += "- #{@name} (file, size=#{size})\n"
	end
end

def read_file(filename)
	f = File.open(filename)
	root = ElfDirectory.new('/', nil)
	current_dir = root
	while line = f.gets do 
		puts "processing '#{line.strip}'" if $debug
		command = nil
		args = nil
		if (line[0] == '$') 
			null, command, args = line.split(' ')
		end

		if (command == "cd")
			if (args == '/')
				# Root is already made
				next
			else
				current_dir = current_dir.get_directory(args)
			end
		elsif (command == "ls")
			# Do nothing with ls
			next
		else
			# If not cd or ls, create new directory / file
			first, second = line.split(' ')
			if (first == 'dir')
				# New Directory
				directory = ElfDirectory.new(second, current_dir)
				current_dir.append(directory)
			else 	
				# New File
				file = ElfFile.new(second, first.to_i)
				current_dir.append(file)
			end
		end
		puts current_dir.print if $debug
	end
	f.close
	root
end

# Part One
puts "What is the sum of the total sizes of those directories?"
root = read_file("input.txt")
puts root.part_one(100000)

puts root.print if $debug

# Part Two
puts "What is the total size of that directory?"
filesystem = ElfFileSystem.new(root, 70000000)
puts filesystem.part_two(30000000)