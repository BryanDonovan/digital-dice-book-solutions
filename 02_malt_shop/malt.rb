require 'pp'

runs = 1000000
lil_dur = 5
bill_dur = 7
hits = 0

runs.times do
  lil_start = Random.rand(30.0)
  bill_start = Random.rand(30.0)

  lil_end = lil_start + lil_dur
  bill_end = bill_start + bill_dur

  if lil_start > bill_start && lil_start < bill_end
    hits += 1
  elsif bill_start > lil_start && bill_start < lil_end
    hits += 1
  end
end

puts
puts hits.to_f/runs
