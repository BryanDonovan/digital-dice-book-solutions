var shuffle = function (o) {
    for (var j, x, i = o.length; i; j = parseInt(Math.random() * i, 10), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
};

var m = 24;
var totalcorrect = 0;
var m_range = [];
for (var i = 0; i < 24; i++) {
    m_range.push(i);
}

var iterations = 1000000;
var correct = 0;

for (var k = 0; k < iterations; k++) {
    correct = 0;
    var shuffled = shuffle(m_range);

    for (var j = 0; j < m_range.length; j++) {
        if (shuffled[j] === j) {
            correct = correct + 1;
        }
    }

    totalcorrect = totalcorrect + correct;
}

var avg = totalcorrect / iterations;

console.log("avg: " + avg);
