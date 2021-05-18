class DisjointCycles
  attr_reader :cycles, :max, :name

  def initialize(cycles, name)
    @cycles = cycles
    @max = cycles.flatten.max
    @name = name
  end

  def next(input)
    raise "Input '#{input}' is greater than max: #{max}" if input > max

    cycles.each do |cycle|
      location = cycle.index(input)
      next if location.nil?

      return cycle[0] if location + 1 == cycle.length

      return cycle[location + 1]
    end
  end

  def of(other_disjoint_cycles)

    "#{name} ○ #{other_disjoint_cycles.name} = "
  end

  def print
    raise 'No cycles present' unless cycles.is_a?(Array)

    disjoint_cycles = cycles.map do |cycle|
      "(#{cycle.join(' ')})"
    end.join(' ○ ')

    "#{name} = #{disjoint_cycles}"
  end
end

delta = DisjointCycles.new([
  [1, 3, 5], [2, 4], [6]
], 'δ')

gamma = DisjointCycles.new([
  [1, 6, 4, 5], [2], [3]
], 'γ')

puts delta.print
# puts gamma.print
# puts delta.of(gamma)
puts 'delta.next(1): ' + delta.next(1).inspect
puts 'delta.next(3): ' + delta.next(3).inspect
puts 'delta.next(5): ' + delta.next(5).inspect
puts 'delta.next(2): ' + delta.next(2).inspect
puts 'delta.next(4): ' + delta.next(4).inspect
puts 'delta.next(6): ' + delta.next(6).inspect

# ADD TESTS
