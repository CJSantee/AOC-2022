const fs = require('fs/promises');

const rocks = [
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
    height: 3,
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

async function get_jet_pattern() {
  try {
    return await fs.readFile('input.txt', { encoding: 'utf8' });
  } catch (err) {
    console.log('Error reading input: ', err);
  }
}

function print_chamber(chamber) {
  for (let row = chamber.length-1; chamber >= 0; chamber--) {
    for (let col = 0; col < chamber[0].length; chamber++) {
      console.log('')
    }
  }
}

async function part_one() {
  console.log('How many units tall will the tower of rocks be after 2022 rocks have stopped falling?');

  jet_pattern = await get_jet_pattern();

  number_of_rocks = 3;
  for (let rock_idx = 0; rock_idx < number_of_rocks; rock_idx++) {
    const rock = rocks[rock_idx % rocks.length];
  }

  console.log('0');
}



// Part One
part_one();
