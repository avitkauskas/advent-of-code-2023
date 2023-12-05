class Garden
  getter seeds
  getter seed_ranges

  @seeds : Array(Int64)
  @seed_ranges : Array(Range(Int64, Int64))
  @seed_to_soil_map : Array(NamedTuple(source: Range(Int64, Int64), destination: Range(Int64, Int64)))
  @soil_to_fertilizer_map : Array(NamedTuple(source: Range(Int64, Int64), destination: Range(Int64, Int64)))
  @fertilizer_to_water_map : Array(NamedTuple(source: Range(Int64, Int64), destination: Range(Int64, Int64)))
  @water_to_light_map : Array(NamedTuple(source: Range(Int64, Int64), destination: Range(Int64, Int64)))
  @light_to_temperture_map : Array(NamedTuple(source: Range(Int64, Int64), destination: Range(Int64, Int64)))
  @temperature_to_humidity_map : Array(NamedTuple(source: Range(Int64, Int64), destination: Range(Int64, Int64)))
  @humidity_to_location_map : Array(NamedTuple(source: Range(Int64, Int64), destination: Range(Int64, Int64)))

  def initialize(filename)
    almanac = File.read(filename).strip.split("\n\n")
    @seeds = almanac[0].split.skip(1).map &.to_i64
    @seed_ranges = almanac[0].split.skip(1)
      .map(&.to_i64).in_slices_of(2)
      .map { |c| Range.new(c[0], c[0] + c[1], exclusive: true) }
    @seed_to_soil_map = read_map almanac[1]
    @soil_to_fertilizer_map = read_map almanac[2]
    @fertilizer_to_water_map = read_map almanac[3]
    @water_to_light_map = read_map almanac[4]
    @light_to_temperture_map = read_map almanac[5]
    @temperature_to_humidity_map = read_map almanac[6]
    @humidity_to_location_map = read_map almanac[7]
  end

  def contains_seed?(seed)
    @seed_ranges.each do |r|
      return true if r.includes? seed
    end
    false
  end

  def seed_to_soil(seed)
    find_destination seed, @seed_to_soil_map
  end

  def soil_to_fertilizer(soil)
    find_destination soil, @soil_to_fertilizer_map
  end

  def fertilizer_to_water(fertilizer)
    find_destination fertilizer, @fertilizer_to_water_map
  end

  def water_to_light(water)
    find_destination water, @water_to_light_map
  end

  def light_to_temperture(light)
    find_destination light, @light_to_temperture_map
  end

  def temperature_to_humidity(temperature)
    find_destination temperature, @temperature_to_humidity_map
  end

  def humidity_to_location(humidity)
    find_destination humidity, @humidity_to_location_map
  end

  def soil_to_seed(soil)
    find_source soil, @seed_to_soil_map
  end

  def fertilizer_to_soil(fertilizer)
    find_source fertilizer, @soil_to_fertilizer_map
  end

  def water_to_fertilizer(water)
    find_source water, @fertilizer_to_water_map
  end

  def light_to_water(light)
    find_source light, @water_to_light_map
  end

  def temperature_to_ligth(temperature)
    find_source temperature, @light_to_temperture_map
  end

  def humidity_to_temperature(humidity)
    find_source humidity, @temperature_to_humidity_map
  end

  def location_to_humidity(location)
    find_source location, @humidity_to_location_map
  end

  private def find_destination(needle, mapping)
    mapping.each do |m|
      if m[:source].includes? needle
        return m[:destination].begin + needle - m[:source].begin
      end
    end
    needle
  end

  private def find_source(needle, mapping)
    mapping.each do |m|
      if m[:destination].includes? needle
        return m[:source].begin + needle - m[:destination].begin
      end
    end
    needle
  end

  private def read_map(map_table)
    map_table.split('\n').skip(1).map do |line|
      destination, source, length = line.split.map &.to_i64
      {source:      Range.new(source, source + length, exclusive: true),
       destination: Range.new(destination, destination + length, exclusive: true)}
    end
  end
end

garden = Garden.new("input/input05.txt")

min_location = garden.seeds
  .map { |e| garden.seed_to_soil e }
  .map { |e| garden.soil_to_fertilizer e }
  .map { |e| garden.fertilizer_to_water e }
  .map { |e| garden.water_to_light e }
  .map { |e| garden.light_to_temperture e }
  .map { |e| garden.temperature_to_humidity e }
  .map { |e| garden.humidity_to_location e }
  .min

puts "Part 1: #{min_location}"

(0..).each do |location|
  humidity = garden.location_to_humidity(location)
  temperature = garden.humidity_to_temperature(humidity)
  light = garden.temperature_to_ligth(temperature)
  water = garden.light_to_water(light)
  fertilizer = garden.water_to_fertilizer(water)
  soil = garden.fertilizer_to_soil(fertilizer)
  seed = garden.soil_to_seed(soil)
  if garden.contains_seed?(seed)
    puts "Part 2: #{location}"
    break
  end
end
