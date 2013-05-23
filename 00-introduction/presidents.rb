# From Digital Dice, page 7
# Note: ruby >= 1.9 is much faster than 1.8.x

m = 24
totalcorrect = 0
m_range = (0.upto m).to_a
iterations = 1000000

for k in (1.upto iterations) do
  correct = 0
  shuffled = m_range.shuffle

  for j in m_range do
    if shuffled[j] == j
      correct += 1
    end
  end

  totalcorrect += correct
end

avg = totalcorrect * 1.0 / iterations

puts "avg: #{avg}"
