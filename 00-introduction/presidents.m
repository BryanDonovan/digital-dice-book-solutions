% From Digital Dice, page 7
% Can be executed with octave.

M = 24;
totalcorrect = 0;

for k = 1:100000
  correct = 0;

  term = randperm(M);

  for j = 1:M
    if term(j) == j
      correct = correct + 1;
    end
  end

  totalcorrect = totalcorrect + correct;
end

totalcorrect / 100000
