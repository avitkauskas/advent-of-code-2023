moves, maps = File.read("input/input08.txt").split("\n\n")

moves = moves.chars.map { |c| c == 'L' ? 0 : 1 }

maps = maps.lines.map &.scan(/[0-9A-Z]+/).map(&.[0])
maps = Hash.zip(maps.map(&.[0]), maps.map { |(_, l, r)| [l, r] })

ans = 0
node = "AAA"
moves.cycle do |move|
  node = maps[node][move]
  ans += 1
  break if node == "ZZZ"
end

puts "Part 1: #{ans}"

nodes = maps.keys.select { |k| k.ends_with?("A") }

steps = nodes.map_with_index do |node, i|
  n = 0_i64
  moves.cycle do |move|
    node = maps[node][move]
    n += 1
    break n if node.ends_with?("Z")
  end
end

ans = steps.reduce { |res, n| res.lcm(n) }

puts "Part 2: #{ans}"
