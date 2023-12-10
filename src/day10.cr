field = File.read_lines("input/input10.txt").map &.chars

MOVES = {
  {'|', { 1, 0}} => { 1, 0},
  {'|', {-1, 0}} => {-1, 0},
  {'-', { 0, 1}} => { 0, 1},
  {'-', { 0,-1}} => { 0,-1},
  {'L', { 1, 0}} => { 0, 1},
  {'L', { 0,-1}} => {-1, 0},
  {'J', { 1, 0}} => { 0,-1},
  {'J', { 0, 1}} => {-1, 0},
  {'7', { 0, 1}} => { 1, 0},
  {'7', {-1, 0}} => { 0,-1},
  {'F', {-1, 0}} => { 0, 1},
  {'F', { 0,-1}} => { 1, 0},
}

def get_start_coords(field)
  start_coords = {0,0}
  r = 0
  while r < field.size
    c = 0
    while c < field[0].size
      if field[r][c] == 'S'
        start_coords = {r, c}
        break
      end
      c += 1
    end
    r += 1
  end
  start_coords
end

def make_move(coords, move)
  {coords[0] + move[0], coords[1] + move[1]}
end

def get_cell(field, coords)
  r, c = coords
  field[r][c]
end

def find_loop(field)
  start = coords = get_start_coords(field)
  path = [start]
  move = {-1, 0}
  loop do
    coords = make_move(coords, move)
    break path if coords == start
    path << coords
    cell = get_cell(field, coords)
    move = MOVES[{cell, move}]
  end
end

path = find_loop(field)
ans = path.size // 2

puts "Part 1: #{ans}"

EXPAND_H = {
  '|' => ['.','|','.'],
  '-' => ['-','-','-'],
  'L' => ['.','L','-'],
  'J' => ['-','J','.'],
  '7' => ['-','7','.'],
  'F' => ['.','F','-'],
  '*' => ['.','*','.'],
}

EXPAND_VU = {
  '|' => '|',
  '-' => '.',
  'L' => '|',
  'J' => '|',
  '7' => '.',
  'F' => '.',
  '*' => '.',
  '.' => '.',
}

EXPAND_VD = {
  '|' => '|',
  '-' => '.',
  'L' => '.',
  'J' => '.',
  '7' => '|',
  'F' => '|',
  '*' => '.',
  '.' => '.',
}

clean_field = Array.new(field.size) { Array.new(field[0].size, '*') }

path.each do |(r,c)|
  clean_field[r][c] = field[r][c]
end

r, c = get_start_coords(field)
clean_field[r][c] = 'L'

expanded_lines = Array(Array(Char)).new 

clean_field.each do |line|
  exp_line = Array(Char).new
  line.each { |ch| exp_line.concat EXPAND_H[ch] }
  expanded_lines << exp_line
end

expanded_field = Array(Array(Char)).new 

expanded_lines.each do |line|
  expanded_field << line.map { |ch| EXPAND_VU[ch] }
  expanded_field << line
  expanded_field << line.map { |ch| EXPAND_VD[ch] }
end

expanded_field.map! do |line|
  line.map! do |ch|
    case ch
    when '*' then 'X'
    when '.' then ' '
    else '*'
    end
  end
end

def flud_field(field)
  rows = (0...field.size)
  cols = (0...field[0].size)

  start = {0,0}
  queue = Deque.new(1, start)
  seen = Set{start}

  while !queue.empty?
    row, col = queue.shift
    field[row][col] = '.'
    next_cells = [] of Tuple(Int32, Int32)
    { {0,-1},{-1,0},{0,1},{1,0} }.each do |r, c|
      nr, nc = {row + r, col + c}
      new_cell = {nr, nc}
      if new_cell[0].in?(rows) && new_cell[1].in?(cols) && field[nr][nc] != '*' && !seen.includes?(new_cell)
        next_cells << new_cell
      end
    end
    seen.concat next_cells
    queue.concat next_cells
  end
  field
end

fluded_field = flud_field(expanded_field)

ans = fluded_field.sum do |line|
  line.count { |ch| ch == 'X' }
end

puts "Part 2: #{ans}"
