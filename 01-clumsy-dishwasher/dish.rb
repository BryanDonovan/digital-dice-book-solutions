require 'pp'
dishwashers = [1, 2, 3, 4, 5]
clumsy_guy = 1
runs = 1000000
clumsy_events = 0

runs.times do
  culprits = []
  broken_count = 0

  5.times do
    if dishwashers.sample(1)[0] === clumsy_guy
      broken_count += 1
    end
  end

  if broken_count >= 4
    clumsy_events += 1
  end
end

puts "clumsy_events: #{clumsy_events}"
prob = clumsy_events * 1.0 / runs
puts "prob: #{prob}"
