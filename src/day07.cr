hands = File.read_lines("input/input07.txt").map do |line|
  cards, bid = line.split
  {cards: cards.chars, bid: bid.to_i}
end

CARDS_NO_JOCKER = "23456789TJQKA"
CARDS_WITH_JOCKER = "J23456789TQKA"

def hand_type_no_jocker(hand)
  hand[:cards].tally.values.sort!.reverse!
end

def hand_type_with_joker(hand)
  tally = hand[:cards].tally
  jockers = tally.delete('J') || 0
  return [5] if jockers == 5
  type = tally.values.sort!.reverse!
  type[0] += jockers
  type
end

ans = hands
  .sort_by! { |h| {hand_type_no_jocker(h), h[:cards].map{ |c| CARDS_NO_JOCKER.index!(c) }} }
  .map_with_index { |h, i| h[:bid] * (i + 1) }
  .sum

puts "Part 1: #{ans}"

ans = hands
  .sort_by! { |h| {hand_type_with_joker(h), h[:cards].map{ |c| CARDS_WITH_JOCKER.index!(c) }} }
  .map_with_index { |h, i| h[:bid] * (i + 1) }
  .sum

puts "Part 2: #{ans}"
