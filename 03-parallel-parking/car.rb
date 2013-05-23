require 'pp'

class Parking
  attr_reader :runs, :n, :distr, :hits

  def initialize(runs, n)
    @runs = runs
    @n = n
    @hits = 0
  end

  def run
    runs.times do
      build_distribution
      car = @distr.sample
      closest_neighbor = get_closest_neighbor(car)
      closest_neighbors_closest_neighbor = get_closest_neighbor(closest_neighbor)

      @hits += 1 if closest_neighbors_closest_neighbor == car
    end
    return self
  end

  def hit_proportion
    @hits.to_f / @runs
  end

  def to_s
    "Nbr of Cars: #{@n}\n" +
    "Runs: #{@runs}\n" +
    "Hit Proportion: #{hit_proportion}"
  end


  private

  def build_distribution
    @distr = []
    @n.times do
      @distr.push Random.rand
    end
    @distr.sort!
  end

  def distance_left(car)
    car_i = @distr.index(car)
    return nil if car_i == 0
    left_car = @distr[car_i - 1]
    return car - left_car
  end

  def distance_right(car)
    car_i = @distr.index(car)
    return nil if car_i == @distr.size - 1
    right_car = @distr[car_i + 1]
    return right_car - car
  end

  def get_left_neighbor(car)
    car_i = @distr.index(car)
    return nil if car_i == 0
    return @distr[car_i - 1]
  end

  def get_right_neighbor(car)
    car_i = @distr.index(car)
    return nil if car_i == @distr.size - 1
    return @distr[car_i + 1]
  end

  def get_closest_neighbor(car)
    left_dist = distance_left(car)
    right_dist = distance_right(car)

    if left_dist && right_dist
      if left_dist < right_dist
        get_left_neighbor(car)
      else
        get_right_neighbor(car)
      end
    else
      return get_left_neighbor(car) if left_dist
      return get_right_neighbor(car) if right_dist
    end
  end
end


runs = 1000000
n = 10

puts Parking.new(runs, n).run.to_s
