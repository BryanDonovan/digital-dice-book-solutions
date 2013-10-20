% Based on solution in Digital Dice Problem 1
% http://press.princeton.edu/chapters/s2_8623.pdf
% Can be executed with Octave.
clumsy_incidents = 0;
runs = 1000000

for k = 1:runs
  broken_dishes = 0;

  for j = 1:5
    rnd = rand;

    if rnd < 0.2
      broken_dishes = broken_dishes + 1;
    end
  end

  if broken_dishes > 3
    clumsy_incidents = clumsy_incidents + 1;
  end
end

clumsy_incidents / runs
