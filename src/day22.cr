bricks = File.read_lines("input/input22.txt").map(&.split('~').map(&.split(',').map(&.to_i)))
# bricks = File.read_lines("input/test.txt").map(&.split('~').map(&.split(',').map(&.to_i)))

def indexes_of_bricks_with_lower_end_at(z, bricks)
  bricks.map_with_index { |b, i| i if {b[0][2], b[1][2]}.min == z }.compact
end

def coord_ranges(brick)
  s, e = brick
  s.zip(e).map &.minmax
end

def top_of(bricks)
  bricks.max_of { |b| {b[0][2], b[1][2]}.max }
end

def empty_space_below(brick, bricks)
  xb, yb, zb = coord_ranges(brick)
  bricks_below = bricks.select do |b|
    x, y, z = coord_ranges(b)
    z[1] < zb[0] && !(x[1] < xb[0] || x[0] > xb[1]) && !(y[1] < yb[0] || y[0] > yb[1])
  end
  return zb[0] - 1 if bricks_below.empty?
  zb[0] - top_of(bricks_below) - 1
end

def bricks_supported(brick, bricks)
  xb, yb, zb = coord_ranges(brick)
  bricks_right_above = bricks.map_with_index do |b, i|
    x, y, z = coord_ranges(b)
    i if z[0] == zb[1] + 1 && !(x[1] < xb[0] || x[0] > xb[1]) && !(y[1] < yb[0] || y[0] > yb[1])
  end.compact
end

def settle_bricks(bricks)
  count = 0
  row = 2
  while row <= top_of(bricks)
    idxs = indexes_of_bricks_with_lower_end_at(row, bricks)
    idxs.each do |idx|
      below = empty_space_below(bricks[idx], bricks)
      if below > 0
        bricks[idx][0][2] -= below
        bricks[idx][1][2] -= below
        count += 1
      end
    end
    row += 1
  end
  count
end

def bricks_possible_to_desintegrate(bricks)
  supported = bricks.map_with_index { |b, i| {i, bricks_supported(b, bricks)}}.to_h
  bricks.map_with_index do |b, i|
    i if supported[i].all? do |s|
      supported.any? { |k, v| s.in?(v) && k != i}
  end
  end.compact
end

settle_bricks(bricks)
ans = bricks_possible_to_desintegrate(bricks).size
puts "Part 1: #{ans}"

def bricks_to_fall(idx, bricks)
  bricks = bricks.clone
  bricks.delete_at(idx)
  settle_bricks(bricks)
end

ans = bricks.size.times.sum { |i| bricks_to_fall(i, bricks) }
puts "Part 2: #{ans}"
