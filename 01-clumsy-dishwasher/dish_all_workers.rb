# The below calculates the probability of *any* dishwasher breaking 4 or more dishes.

require 'pp'
dishwashers = [1, 2, 3, 4, 5]
clumsy_guy = 1
runs = 1000000

clumsy_events = 0

runs.times do
  culprits = []

  1.upto(5) do |broken_dish|
    culprits.push(dishwashers.sample(1)[0])
  end

  dishwashers.each do |dishwasher|
    broken_count = culprits.select {|culprit| culprit === dishwasher}.size
    if broken_count >= 4
      clumsy_events += 1
    end
  end
end

puts "clumsy_events: #{clumsy_events}"
prob = clumsy_events * 1.0 / runs
puts "prob: #{prob}"
