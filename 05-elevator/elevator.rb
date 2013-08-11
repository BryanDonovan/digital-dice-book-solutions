class Elevator
  DIRECTIONS = [:up, :down]

  attr_accessor :floors, :direction, :position, :distance_traveled

  def initialize(args)
    @floors = args[:floors].to_f
    @direction = :up
    @position = 0.0
  end

  def jump_to_random_location
    self.distance_traveled = 0.0
    self.position = Random.rand()
    self.direction = Elevator::DIRECTIONS.sample
    nil
  end

  def total_distance_from(new_position)
    if position < new_position
      if direction == :up
        return new_position - position
      else
        # elevator goes down, then back up
        return position + new_position
      end
    else
      if direction == :down
        return position - new_position
      else
        # elevator goes up, then back down
        return 2 * (1.0 - position) + (position - new_position)
      end
    end
  end

  def get_floor_position(floor)
    (floor - 1) / (floors.to_f - 1)
  end

  def move_to(new_floor)
    new_position = get_floor_position(new_floor)

    self.distance_traveled = total_distance_from(new_position)

    if position < new_position
      if direction == :down
        self.direction = :up
      end
    else
      if direction == :up
        self.direction = :down
      end
    end

    self.position = new_position
  end
end

class Building
  attr_accessor :floors, :waiting_floor, :elevators

  def initialize(args)
    @floors = args[:floors]
    @waiting_floor = args[:waiting_floor]
    @elevators = args[:elevators]
  end

  def move_elevators_to_random_locations
    elevators.each do |elevator|
      elevator.jump_to_random_location
    end
  end

  def arriving_elevator
    elevators.each {|elev| elev.move_to(waiting_floor)}
    elevators.sort! {|elev1, elev2| elev1.distance_traveled <=> elev2.distance_traveled}
    elevators.first
  end
end

if __FILE__ == $0
  @runs = 100000
  @coming_down = 0

  def run
    floors = 7
    waiting_floor = 2
    elevators = [Elevator.new(floors: floors), Elevator.new(floors: floors)]
    building = Building.new(floors: floors, waiting_floor: waiting_floor, elevators: elevators)

    @runs.times do
      building.move_elevators_to_random_locations
      arriving_elevator = building.arriving_elevator
      if arriving_elevator.direction == :down
        @coming_down += 1
      end
    end
  end

  expected = 13.0 / 18.0

  run()
  prop_coming_down = (@coming_down * 1.000) / @runs
  puts "Proportion coming down: #{prop_coming_down}"
  puts "Expected to be near #{expected}"
end
