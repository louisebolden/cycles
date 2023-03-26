class DisjointCycles
  attr_reader :cycles, :max, :name

  def initialize(cycles, name)
    @cycles = cycles
    @max = cycles_flat.max
    @name = name
  end

  def cycles_flat
    @cycles_flat ||= cycles.flatten
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
    current_pointer = 1
    stop_at = current_pointer

    to_include = (2..max).to_a

    new_disjoint_cycles = []
    current_cycle = []

    loop do
      current_cycle.push(current_pointer)

      next_pointer = self.next(other_disjoint_cycles.next(current_pointer))

      to_include.delete(next_pointer)
      current_pointer = next_pointer

      if current_pointer == stop_at
        new_disjoint_cycles.push(current_cycle)

        break if to_include.length == 0

        current_pointer = to_include.shift
        stop_at = current_pointer

        current_cycle = []
      end
    end

    DisjointCycles.new(new_disjoint_cycles, "#{name} ○ #{other_disjoint_cycles.name}")
  end

  def to_the_power_of(power)
    raise 'Power must be an integer' unless power.is_a?(Integer)
    raise 'Not ready to calculate inverses yet' if power < 0

    return [] if power == 0 # This should be identity permutation? Best notation?

    resulting_composition = self
    composition_count = 1

    while composition_count < power
      resulting_composition = resulting_composition.of(self)
      composition_count += 1
    end

    resulting_composition
  end

  def print
    raise 'No cycles present' unless cycles.is_a?(Array)

    disjoint_cycles = cycles.map do |cycle|
      "(#{cycle.join(' ')})"
    end.join(' ○ ')

    "#{name} = #{disjoint_cycles}"
  end
end

alpha = DisjointCycles.new([
  [1, 3, 10, 9, 8, 4], [2, 5, 6], [7]
], 'α')

delta = DisjointCycles.new([
  [1, 3, 5, 7], [2, 4, 8, 12], [6, 9, 10, 11]
], 'δ')

gamma = DisjointCycles.new([
  [1, 2, 4, 8], [3, 6, 9, 12], [5, 10], [7], [11]
], 'γ')

puts delta.print
puts gamma.print
puts '--'
puts delta.of(gamma).print
puts gamma.of(delta).print
puts '--'
puts alpha.print
puts alpha.of(alpha).print
puts alpha.of(alpha.of(alpha)).print

# TESTS
def run_test(description, expected, received)
  unless received == expected
    raise "\nTEST FAILED: #{description}.\nExpected: #{expected}\nReceived: #{received}"
  end
end

[
  [3, delta.next(1)],
  [5, delta.next(3)],
  [7, delta.next(5)],
  [4, delta.next(2)],
  [8, delta.next(4)],
  [9, delta.next(6)],
  [6, delta.next(11)]
].map do |expected_and_received|
  expected, received = expected_and_received
  run_test('delta.next should return the correct next element', expected, received)
end

[
  [7, gamma.next(7)]
].map do |expected_and_received|
  expected, received = expected_and_received
  run_test('gamma.next should return the correct next element', expected, received)
end
