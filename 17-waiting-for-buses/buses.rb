# This is definitely not the most efficient way to calculate the solution

class BusLine
  attr_accessor :arrival_time

  def initialize(args)
    @arrival_time = args[:arrival_time]
  end
end

class WaitInterval
  attr_accessor :start_time, :arrival_time

  def initialize(args)
    @start_time = args[:start_time]
    @arrival_time = args[:arrival_time]
  end

  def wait_time
    if start_time <= arrival_time
      to_minutes(arrival_time - start_time)
    else
      to_minutes(1 - start_time + arrival_time)
    end
  end

  private

  def to_minutes(decimal)
    return decimal * 60
  end
end

class Traveler
  attr_accessor :start_time

  def initialize(args)
    @start_time = args[:start_time]
  end
end

class Trip
  attr_accessor :traveler, :buslines, :wait_time

  def initialize(args)
    @traveler = args[:traveler]
    @buslines = args[:buslines]
  end

  def start
    @wait_time = get_wait_time()
  end

  private

  def get_wait_time
    shortest_wait = 60
    buslines.each do |busline|
      _wait_time = WaitInterval.new(start_time: @traveler.start_time, arrival_time: busline.arrival_time).wait_time

      if _wait_time < shortest_wait
        shortest_wait = _wait_time
      end
    end

    return shortest_wait
  end
end

class Runner
  attr_accessor :busline_qty, :buslines, :wait_time

  def initialize(args)
    @busline_qty = args[:busline_qty]
    @buslines = get_buslines()
  end

  def run
    traveler = Traveler.new(start_time: Random.rand())
    trip = Trip.new(traveler: traveler, buslines: @buslines)
    trip.start
    @wait_time = trip.wait_time
  end

  private

  def get_buslines
    _buslines = []

    @busline_qty.times do |i|
      arrival_time = Random.rand()
      if i == 0
        arrival_time = 0
      end

      _buslines << BusLine.new(arrival_time: arrival_time)
    end

    _buslines
  end
end

if __FILE__ == $0
  busline_qty = 2
  n = 10000
  total_time = 0

  n.times do
    runner = Runner.new(busline_qty: busline_qty)
    runner.run
    total_time += runner.wait_time
  end

  puts
  puts "Runs: #{n}"
  puts "Number of buslines: #{busline_qty}"
  puts "Avg wait time: " + (total_time / n).to_s
  puts
end
