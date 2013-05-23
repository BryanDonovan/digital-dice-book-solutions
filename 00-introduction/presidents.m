% Based on solution in Digital Dice introduction, page 7
% http://press.princeton.edu/chapters/i8623.pdf
% Can be executed with Octave.

runs = 24;
total_correct = 0;

for k = 1:100000
  loop_correct = 0;

  term = randperm(runs);

  for j = 1:runs
    if term(j) == j
      loop_correct = loop_correct + 1;
    end
  end

  total_correct = total_correct + loop_correct;
end

total_correct / 100000
