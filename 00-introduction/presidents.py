# From Digital Dice, page 7
import random

m = 24
totalcorrect = 0
m_range = range(0, m)
iterations = 1000000 # Python (or my implementation) is pretty slow with a million iterations.

for k in range(1, iterations):
    correct = 0
    random.shuffle(m_range)

    for j in range(0, m):
        if m_range[j] == j:
            correct += 1

    totalcorrect += correct

avg = totalcorrect * 1.0 / iterations

print "avg: ", avg
