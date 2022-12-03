require 'set'

# Part One
puts "What would your total score be if everything goes exactly according to your strategy guide?"

elf_shapes = Hash['A' => 'rock', 'B' => 'paper', 'C' => 'scissors']

my_shapes = Hash['X' => 'rock', 'Y' => 'paper', 'Z' => 'scissors']

rules = Hash[Set['rock', 'paper'] => 'paper', Set['rock', 'scissors'] => 'rock', Set['paper', 'scissors'] => 'scissors']

shape_score = Hash['rock' => 1, 'paper' => 2, 'scissors' => 3]

outcome_score = Hash['loss' => 0, 'draw' => 3, 'win' => 6]

f = File.open('input.txt')

total_score = 0
while line = f.gets do 
	game = line.split
	elf_move = elf_shapes[game[0]]
	my_move = my_shapes[game[1]]
	winner = rules[Set[elf_move, my_move]]
	if(!winner)
		# Draw
		total_score += outcome_score['draw']
	elsif(winner == my_move)
		# Win
		total_score += outcome_score['win']
	else
		# Loss
		total_score += outcome_score['loss'] 
	end
	total_score += shape_score[my_move]
end

puts total_score
f.close 

# Part Two
puts "Following the Elf's instructions for the second column, what would your total score be if everything goes exactly according to your strategy guide?"

outcome = Hash['X' => 'loss', 'Y' => 'draw', 'Z' => 'win']

inv_rules = Hash['paper' => Set['paper', 'rock'], 'rock' => Set['rock', 'scissors'], 'scissors' => Set['scissors', 'paper']]

beats = Hash['paper' => 'rock', 'rock' => 'scissors', 'scissors' => 'paper']

f = File.open('input.txt')

total_score = 0
while line = f.gets do 
	game = line.split
	elf_move = elf_shapes[game[0]]
	result = outcome[game[1]]

	if(result == 'draw')
		my_move = elf_move
	elsif(result == 'loss')
		my_move = beats[elf_move]
	else
		moves = Set['rock', 'paper', 'scissors']
		moves.delete(elf_move)
		moves.delete(beats[elf_move])
		my_move = moves.to_a[0]
	end
	total_score += outcome_score[result]
	total_score += shape_score[my_move]
end

puts total_score