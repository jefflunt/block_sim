class Sim
  attr_reader :map
  attr_reader :turn_length

  def initialize(map:, turn_length:)
    @map = map
    @turn_length = turn_length
  end

  def tick
    map.cells.each{ |c| c.tick }
    sleep(turn_length)
  end
end
