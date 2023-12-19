rules, parts = File.read("input/input19.txt").split("\n\n")

rules = rules.lines.map do |line|
  name, rules = line.split('{')
  rules = rules.chomp('}').split(',')
  rules = rules.map do |rule|
    if rule.includes? ':'
      _, typ, op, val, nxt = rule.match! /(.)([><])(\d+):(\w+)/
      {typ: typ, op: op, val: val.to_i, nxt: nxt}
    else
      {typ: "z", op: "<", val: 1, nxt: rule}
    end
  end
  {name, rules}
end.to_h

parts = parts.lines.map do |line|
  cats = line[1...-1].split(',').map(&.split('='))
    .map { |(cat, val)| {cat, val.to_i } }
    .concat([{"z", 0}, {"res", 0}]).to_h
end

ops = {"<" => ->(a : Int32, b : Int32) { a < b },
       ">" => ->(a : Int32, b : Int32) { a > b }}

parts.each_with_index do |part, i|
  flow = "in"
  while flow != "A" && flow != "R"
    rules[flow].each do |rule|
      if ops[rule[:op]].call(part[rule[:typ]], rule[:val])
        flow = rule[:nxt]
        break
      end
    end
  end
  parts[i]["res"] = flow == "A" ? 1 : 0
end

ans = parts.sum do |p| 
  p["res"] == 0 ? 0 : p["x"] + p["m"] + p["a"] + p["s"]
end

puts "Part 1: #{ans}"

range = (1..4000)
init_state = {"x" => range, "m" => range, "a" => range, "s" => range}

accepted = [] of Hash(String, Range(Int32, Int32))

queue = Deque.new(1, {init_state, "in"})

while !queue.empty?
  state, flow = queue.shift
  
  rules[flow].each do |rule|
    typ, op, val, nxt = rule[:typ], rule[:op], rule[:val], rule[:nxt]
    
    if typ == "z"
      if nxt == "A"
        accepted << state.dup
      elsif nxt != "R"
        queue << {state.dup, nxt}
      end

    else
      rule_in_range = op == "<" ? 1..(val - 1) : (val + 1)..4000
      rule_out_range = op == "<" ? val..4000 : 1..val

      state_range = state[typ]
      
      next_in_range = Math.max(state_range.begin, rule_in_range.begin)..Math.min(state_range.end, rule_in_range.end)
      next_out_range = Math.max(state_range.begin, rule_out_range.begin)..Math.min(state_range.end, rule_out_range.end)
      
      if next_in_range.size > 0
        next_state = state.dup
        next_state[typ] = next_in_range
        if nxt == "A"
          accepted << next_state.dup
        elsif nxt != "R"
          queue << {next_state.dup, nxt}
        end
      end

      if next_out_range.size > 0
        state[typ] = next_out_range
      end
    end
  end
end

ans = accepted.sum do |acc|
  acc.reduce(1_i64) { |acc, (_, range)| acc * range.size }
end

puts "Part 2: #{ans}"
