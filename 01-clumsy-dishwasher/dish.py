import random

dishwashers = [1, 2, 3, 4, 5]
clumsy_guy = 1
runs = 1000000

clumsy_events = 0

for run in range(0, runs):
    culprits = []
    broken_count = 0

    for broken_dish in range(0, 5):
        # This is way faster:
        if random.random() < 0.2:
        # But this is clearer IMO:
        #if random.choice(dishwashers) == clumsy_guy:
            broken_count += 1

    if broken_count >= 4:
        clumsy_events += 1

print "clumsy_events: ", clumsy_events
prob = clumsy_events * 1.0 / runs
print "prob: ", prob

assert(prob < 0.007 and prob > 0.005)
