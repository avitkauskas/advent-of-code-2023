lines = File.read_lines("input/input11.txt")

galaxies = [] of Tuple(Int64, Int64)
lines.each_with_index do |row, r|
  row.chars.each_with_index do |ch, c|
    galaxies << {r.to_i64, c.to_i64} if ch == '#'
  end
end

def expand_galaxies(galaxies, expansion_times)
  expansion = expansion_times - 1
  galaxies = galaxies.dup

  rows = galaxies.max_of &.[0]
  cols = galaxies.max_of &.[1]

  empty_rows = Set.new(0..rows) - galaxies.map &.[0]
  empty_cols = Set.new(0..cols) - galaxies.map &.[1]

  empty_rows.each_with_index do |row, i|
    galaxies.map! do |(r, c)|
      r > row + (i * expansion) ? {r + expansion, c} : {r, c}
    end
  end

  empty_cols.each_with_index do |col, i|
    galaxies.map! do |(r, c)|
      c > col + (i * expansion) ? {r, c + expansion} : {r, c}
    end
  end
  
  galaxies
end

ans = expand_galaxies(galaxies, 2).each_combination(2).sum do |(g1, g2)|
  (g1[0] - g2[0]).abs + (g1[1] - g2[1]).abs
end

puts "Part 1: #{ans}"

ans = expand_galaxies(galaxies, 1_000_000).each_combination(2).sum do |(g1, g2)|
  (g1[0] - g2[0]).abs + (g1[1] - g2[1]).abs
end

puts "Part 2: #{ans}"
