crates = [['a', 'b', 'c'], ['x', 'y', 'z']]

print crates
print "\n"

# Goal: move 'b' and 'c' to arr_two, while maintaining their order
# i.e. "move 2 from arr_one to arr_two"

num_to_move = 3
move_from = 1
move_to = 2

cargo = []
for moving in 1..num_to_move do 
	cargo.unshift(crates[move_from-1].pop)
end
crates[move_to - 1] += cargo

print crates[move_to - 1]
print "\n"