$debug = false

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

	def subprint(subdirectory)
		str = "  "*subdirectory
		str += "- #{@name} (file, size=#{size})\n"
	end
end

# Part One
puts "What is the sum of the total sizes of those directories?"

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

puts read_file("input.txt").print