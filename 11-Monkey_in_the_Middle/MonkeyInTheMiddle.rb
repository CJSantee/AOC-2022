OPERATORS = {
	"+" => :+,
	"*" => :*
}

class Monkey
	attr_accessor :items, :operation, :test, :inspected

	def initialize(items, operation, test)
		@items = items
		@operation = operation
		@test = test
		@inspected = 0
	end

	def to_s
		str = "  Starting items: #{items.join(', ')}\n  Operation: new = old #{operation[:operator]} #{operation[:operand]}\n  Test: divisible by #{test[:divisible_by]}\n    If true: throw to monkey #{test[:if_true]}\n    If false: throw to monkey #{test[:if_false]}"
	end
end

def read_file(filename)
	f = File.open(filename)
	monkeys = []
	items = []
	operation = {
		operator: nil,
		operand: nil
	}
	test = {
		divisible_by: nil,
		if_true: nil,
		if_false: nil
	} 
	while line = f.gets do 
		command, value = line.strip.split(':')
		
		if (command == "Starting items")
			items = value.split(',').map(&:strip).map(&:to_i)
		end
		if (command == "Operation")
			operator, operand = value.split(' ').values_at(3, 4)
			operation[:operator] = OPERATORS[operator]
			operation[:operand] = operand == "old" ? operand : operand.to_i 
		end
		if (command == "Test")
			test[:divisible_by] = value.split(' ').last.to_i
		end
		if (command == "If true")
			test[:if_true] = value.split(' ').last.to_i
		end
		if (command == "If false")
			test[:if_false] = value.split(' ').last.to_i
		end
		if (command == nil) # Make a monkey!
			op = operation.clone 
			tst = test.clone
			monkey = Monkey.new(items, op, tst)
			monkeys.append(monkey)
		end
	end
	# Add last monkey
	monkey = Monkey.new(items, operation, test)
	monkeys.append(monkey)
	f.close
	return monkeys
end

def part_one(monkeys)
	num_rounds = 20
	for round in 1..num_rounds do 
		monkeys.each do |monkey|
			operator = monkey.operation[:operator]
			operand = monkey.operation[:operand]
			monkey.items.each.with_index do |item, idx|  
				monkey.items[idx] = operand == "old" ? item.send(operator, item) : item.send(operator, operand)
				monkey.items[idx] = monkey.items[idx] / 3
				if (monkey.items[idx] % monkey.test[:divisible_by] == 0)
					monkeys[monkey.test[:if_true]].items.append(monkey.items[idx])
				else
					monkeys[monkey.test[:if_false]].items.append(monkey.items[idx])
				end
				monkey.inspected += 1
			end
			monkey.items = []
		end
	end

	most_inspected = monkeys[0].inspected
	second_most_inspected = monkeys[1].inspected
	for idx in 2..(monkeys.size-1) do 
		inspected = monkeys[idx].inspected
		if (inspected > second_most_inspected)
			if (inspected > most_inspected)
				second_most_inspected = most_inspected
				most_inspected = inspected
			else
				second_most_inspected = inspected
			end
		end
	end

	monkey_business = most_inspected * second_most_inspected
end

def part_two(monkeys)
	num_rounds = 10000
	lcm = 9699690
	for round in 1..num_rounds do 
		monkeys.each do |monkey|
			operator = monkey.operation[:operator]
			operand = monkey.operation[:operand]
			monkey.items.each.with_index do |item, idx|  
				monkey.items[idx] = operand == "old" ? item.send(operator, item) : item.send(operator, operand)
				num = lcm * 2
				while (monkey.items[idx] > num) do 
					if (monkey.items[idx] > num * 100000)
						monkey.items[idx] -= num * 100000
					elsif (monkey.items[idx] > num * 10000)
						monkey.items[idx] -= num * 10000
					elsif (monkey.items[idx] > num * 1000)
						monkey.items[idx] -= num * 1000
					elsif (monkey.items[idx] > num * 100)
						monkey.items[idx] -= num * 100
					elsif (monkey.items[idx] > num * 10)
						monkey.items[idx] -= num * 10
					else
						monkey.items[idx] -= lcm
					end
				end
				if (monkey.items[idx] % monkey.test[:divisible_by] == 0)
					monkeys[monkey.test[:if_true]].items.append(monkey.items[idx])
				else
					monkeys[monkey.test[:if_false]].items.append(monkey.items[idx])
				end
				monkey.inspected += 1
			end
			monkey.items = []
		end
	end

	most_inspected = monkeys[0].inspected
	second_most_inspected = monkeys[1].inspected
	for idx in 2..(monkeys.size-1) do 
		inspected = monkeys[idx].inspected
		if (inspected > second_most_inspected)
			if (inspected > most_inspected)
				second_most_inspected = most_inspected
				most_inspected = inspected
			else
				second_most_inspected = inspected
			end
		end
	end

	monkey_business = most_inspected * second_most_inspected
end

# Part One
puts "What is the level of monkey business after 20 rounds of stuff-slinging simian shenanigans?"
monkeys = read_file("input.txt")

puts part_one(monkeys)

# monkeys.each.with_index do |monkey, idx|
# 	puts "Monkey #{idx}:"
# 	puts monkey
# 	print "\n"
# end

# Part Two 
puts "what is the level of monkey business after 10000 rounds?"
monkeys = read_file("input.txt")

puts part_two(monkeys)