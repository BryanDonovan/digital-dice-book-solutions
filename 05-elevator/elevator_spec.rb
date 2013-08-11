require '../ruby_setup'
require './elevator'

describe Elevator do
  before do
    @floors = 7
    @elevator = Elevator.new(floors: @floors)
  end

  it "can be instantiated" do
    @elevator.must_be_instance_of(Elevator)
  end

  it "has the specified number of floors" do
    @elevator.floors.must_equal(@floors)
  end

  it "has a starting direction of 'up'" do
    @elevator.direction.must_equal(:up)
  end

  it "has a starting position of 0.0" do
    @elevator.position.must_equal(0.0)
  end

  describe "#jump_to_random_location" do
    before do
      @actual_positions = []
      @actual_directions = []

      15.times do
        @elevator.jump_to_random_location
        @actual_directions << @elevator.direction
        @actual_positions << @elevator.position
      end
    end

    it "changes the elevator's position to a float between 0 and @floors" do
      uniq_positions = @actual_positions.uniq
      uniq_positions.size.wont_equal 1

      uniq_positions.each do |pos|
        pos.must_be_instance_of Float
      end
    end

    it "sets the elevator's direction to randomly-chosen :up or :down" do
      uniq_directions = @actual_directions.uniq
      uniq_directions.size.wont_equal 1

      uniq_directions.each do |dir|
        [:up, :down].must_include(dir)
      end
    end
  end

  describe "#get_floor_position" do
    it "returns correct position, normalized to 1.0" do
      pos = @elevator.get_floor_position(2)
      expected = 1.0 / 6
      pos.to_f.must_equal(expected.to_f)
    end
  end

  describe "#move_to" do
    before do
      @elevator = Elevator.new(floors: @floors)
      @new_floor = 2.0
      @new_pos = @elevator.get_floor_position(@new_floor) # 1/6
    end

    describe "when elevator is below new_position and moving up" do
      before do
        @pos = 0.6 / 6
        @elevator.position = @pos
        @elevator.direction = :up
        @elevator.move_to(@new_floor)
      end

      it "sets elevator's position to new_position" do
        @elevator.position.must_equal(@new_pos)
      end

      it "sets distance_traveled to difference between positions" do
        expected = @new_pos - @pos
        @elevator.distance_traveled.must_be_close_to(expected, 0.001)
      end

      it "does not change elevator's direction" do
        @elevator.direction.must_equal(:up)
      end
    end

    describe "when elevator is below new_position and moving down" do
      before do
        @pos = 0.6 / 6
        @elevator.position = @pos
        @elevator.direction = :down
        @elevator.move_to(@new_floor)
      end

      it "sets elevator's position to new_position" do
        @elevator.position.must_equal(@new_pos)
      end

      it "sets distance_traveled to difference between positions plus turnaround distance" do
        expected = @new_pos + @pos
        @elevator.distance_traveled.must_be_close_to(expected, 0.001)
      end

      it "changes elevator's direction" do
        @elevator.direction.must_equal(:up)
      end
    end

    describe "when elevator is above new_position and moving down" do
      before do
        @pos = 1.2 / 6
        @elevator.position = @pos
        @elevator.direction = :down
        @elevator.move_to(@new_floor)
      end

      it "sets elevator's position to new_position" do
        @elevator.position.must_equal(@new_pos)
      end

      it "sets distance_traveled to difference between positions" do
        expected = @pos - @new_pos
        @elevator.distance_traveled.must_be_close_to(expected, 0.001)
      end

      it "does not change elevator's direction" do
        @elevator.direction.must_equal(:down)
      end
    end

    describe "when elevator is above new_position and moving up" do
      before do
        @pos = 1.2 / 6
        @elevator.position = @pos
        @elevator.direction = :up
        @elevator.move_to(@new_floor)
      end

      it "sets elevator's position to new_position" do
        @elevator.position.must_equal(@new_pos)
      end

      it "sets distance_traveled to difference between positions plus turnaround distance" do
        expected = (2 * (1.0 - @pos)) + (@pos - @new_pos)
        @elevator.distance_traveled.must_be_close_to(expected, 0.001)
      end

      it "changes elevator's direction" do
        @elevator.direction.must_equal(:down)
      end
    end
  end
end

describe Building do
  before do
    @floors = 7
    @waiting_floor = 2
    @elevators = [Elevator.new(floors: @floors), Elevator.new(floors: @floors)]
    @building = Building.new(waiting_floor: @waiting_floor, elevators: @elevators)
  end

  it "can be instantiated" do
    @building.must_be_instance_of(Building)
  end

  it "has the specified waiting_floor" do
    @building.waiting_floor.must_equal(@waiting_floor)
  end

  it "has specified elevators" do
    @building.elevators.must_equal(@elevators)
  end

  describe "#move_elevators_to_random_locations" do
    it "calls #jump_to_random_location for each elevator" do
      @mock_elevators = [MiniTest::Mock.new, MiniTest::Mock.new]
      @mock_elevators.each do |elev|
        elev.expect(:jump_to_random_location, nil)
      end

      building = Building.new(floors: @floors, waiting_floor: @waiting_floor, elevators: @mock_elevators)
      building.move_elevators_to_random_locations
      @mock_elevators.each do |elev|
        elev.verify
      end
    end
  end

  describe "#arriving_elevator" do
    before do
      @elevator1 = Elevator.new(floors: @floors)
      @elevator2 = Elevator.new(floors: @floors)
      @elevator1.position = @elevator1.get_floor_position(2.2)
      @elevator1.direction = :down

      @elevator2.position = @elevator2.get_floor_position(1.9)
      @elevator2.direction = :down

      @elevators = [@elevator1, @elevator2]
      @building = Building.new(floors: @floors, waiting_floor: @waiting_floor, elevators: @elevators)
    end

    it "returns the closest elevator to the waiting_floor, heading towards it" do
      @building.arriving_elevator.must_equal @elevator1
    end
  end
end
