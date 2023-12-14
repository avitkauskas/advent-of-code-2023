input = File.read_lines("input/input14.txt").map &.chars

def empty_north(platform, row, col)
  row -= 1
  while row >= 0 && platform[row][col] == '.'
    row -= 1
  end
  row + 1
end

def empty_south(platform, row, col)
  row += 1
  while row < platform.size && platform[row][col] == '.'
    row += 1
  end
  row - 1
end

def empty_west(platform, row, col)
  col -= 1
  while col >= 0 && platform[row][col] == '.'
    col -= 1
  end
  col + 1
end

def empty_east(platform, row, col)
  col += 1
  while col < platform[0].size && platform[row][col] == '.'
    col += 1
  end
  col - 1
end

def north(platform)
  1.to(platform.size - 1) do |row|
    0.to(platform[0].size - 1) do |col|
      if platform[row][col] == 'O'
        r = empty_north(platform, row, col)
        if r < row
          platform[r][col] = 'O'
          platform[row][col] = '.'
        end
      end
    end
  end
  platform
end

def south(platform)
  (platform.size - 2).to(0) do |row|
    0.to(platform[0].size - 1) do |col|
      if platform[row][col] == 'O'
        r = empty_south(platform, row, col)
        if r > row
          platform[r][col] = 'O'
          platform[row][col] = '.'
        end
      end
    end
  end
  platform
end

def west(platform)
  1.to(platform[0].size - 1) do |col|
    0.to(platform.size - 1) do |row|
      if platform[row][col] == 'O'
        c = empty_west(platform, row, col)
        if c < col
          platform[row][c] = 'O'
          platform[row][col] = '.'
        end
      end
    end
  end
  platform
end

def east(platform)
  (platform[0].size - 2).to(0) do |col|
    0.to(platform.size - 1) do |row|
      if platform[row][col] == 'O'
        c = empty_east(platform, row, col)
        if c > col
          platform[row][c] = 'O'
          platform[row][col] = '.'
        end
      end
    end
  end
  platform
end

def cycle(platform)
  platform = north(platform)
  platform = west(platform)
  platform = south(platform)
  platform = east(platform)
  platform
end

def load(platform)
  load = 0
  platform.size.times do |row|
    platform[0].size.times do |col|
      if platform[row][col] == 'O'
        load += platform.size - row
      end
    end
  end
  load
end

platform = input.clone
ans = load(north(platform))

puts "Part 1: #{ans}"

cache = Hash(String, Int32).new

platform = input.clone
1.to(1_000_000_000) do |i|
  platform = cycle(platform)
  hash = platform.map(&.join).join
  if cache.has_key? hash
    remaining = (1_000_000_000 - cache[hash]) % (i - cache[hash])
    remaining.times do
      platform = cycle(platform)
    end
    break
  end
  cache[hash] = i
end

ans = load(platform)

puts "Part 2: #{ans}"
