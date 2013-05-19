clumsy = 0;

for k = 1:1000000
  brokendishes = 0;

  for j = 1:5
    r = rand;

    if r < 0.2
      brokendishes = brokendishes + 1;
    end
  end

  if brokendishes > 3
    clumsy = clumsy + 1;
  end
end

clumsy / 1000000
