# Advent of Code 2022

## About
[Advent of Code](https://adventofcode.com/) is an Advent calendar of small programming puzzles for a variety of skill sets and skill levels that can be solved in any programming language you like.

# Day 15
Starting to document my solutions with daily write-ups about each days problem and the techniques I used to solve it. [Today's problem](https://adventofcode.com/2022/day/15) seemed like a perfect opportunity to start writing a library with reusable tools for my solutions. I started by writing an [input string parser](./Tools.rb) where I could write formatted strings to extract integer values from input strings.

### Part One
Calculated available positions exclusively on the check_row using the manhattan distance of each sensor and its beacon and the vertical distance between the sensor and the check_row. Subtract the number of beacons or sensors that exist on the row. 

### Part Two
Doing this for every row would take 456days to complete calcuation. I had to research alternative solutions with the [AOC Reddit](https://www.reddit.com/r/adventofcode/). I landed on implementing the following descrption of a solution: 
```
Walk along the edge of the diamonds created by the sensors and for every of these positions, check if it is within range of any of the sensors. If not, we have found the result.
```

# Day 16
