DIRS = [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]

garden = File.read_lines("input/input21.txt").map &.chars

start = {0, 0}
garden.each_with_index do |row, r|
  row.each_with_index do |cell, c|
    if cell == 'S'
      start = {r, c}
      garden[r][c] = '.'
      break
    end
  end
end

rows = garden.size
cols = garden[0].size

elf_steps = 26_501_365_u64
additional_fields = (elf_steps - start[0]) // rows

initial_steps = 2 * rows + start[0]

possible_locations = [] of Tuple(Int32, Int32)

queue = Deque.new(1, {start, 0})
seen = Set{ {start, 0} }

while !queue.empty?
  curr, steps = queue.shift
  seen.delete({curr, steps})
  if steps == initial_steps
    possible_locations << curr
  else
    row, col = curr
    DIRS.each do |r, c|
      nr = row + r
      nc = col + c
      modr = nr % rows
      modc = nc % cols
      pos = { {nr, nc}, steps + 1 }
      if garden[modr][modc] != '#' && !seen.includes?(pos)
        queue << pos
        seen << pos
      end
    end
  end
end

tt = possible_locations.select { |r, c| r.in?(-rows...0) && c.in?(0...cols) }.size
cc = possible_locations.select { |r, c| r.in?(0...rows) && c.in?(0...cols) }.size

nn = possible_locations.select { |r, c| r.in?(-(rows * 2)...-rows) && c.in?(0...cols) }.size
ss = possible_locations.select { |r, c| r.in?((rows * 2)...(rows * 3)) && c.in?(0...cols) }.size
ww = possible_locations.select { |r, c| r.in?(0...rows) && c.in?(-(cols * 2)...-cols) }.size
ee = possible_locations.select { |r, c| r.in?(0...rows) && c.in?((cols * 2)...(cols * 3)) }.size

nw = possible_locations.select { |r, c| r.in?(-rows...0) && c.in?(-cols...0) }.size
ne = possible_locations.select { |r, c| r.in?(-rows...0) && c.in?(cols...(cols * 2)) }.size
sw = possible_locations.select { |r, c| r.in?(rows...(rows * 2)) && c.in?(-cols...0) }.size
se = possible_locations.select { |r, c| r.in?(rows...(rows * 2)) && c.in?(cols...(cols * 2)) }.size

nw1 = possible_locations.select { |r, c| r.in?(-(rows * 2)...-rows) && c.in?(-cols...0) }.size
ne1 = possible_locations.select { |r, c| r.in?(-(rows * 2)...-rows) && c.in?(cols...(cols * 2)) }.size
sw1 = possible_locations.select { |r, c| r.in?((rows * 2)...(rows * 3)) && c.in?(-cols...0) }.size
se1 = possible_locations.select { |r, c| r.in?((rows * 2)...(rows * 3)) && c.in?(cols...(cols * 2)) }.size

n_tt = additional_fields * additional_fields
n_cc = (additional_fields - 1) * (additional_fields - 1)
n_hh = additional_fields - 1
n_qq = additional_fields

ans = n_tt * tt + n_cc * cc + 
  nn + ss + ww + ee + 
  n_hh * (nw + ne + sw + se) +
  n_qq * (nw1 + ne1 + sw1 + se1)

puts "Part 2: #{ans}"
