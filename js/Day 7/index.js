const fs = require('fs');
const parse = require('./parser');
const evaluator = require('./evaluator');

const input = fs.readFileSync('C:\\Users\\alligator\\dev\\aoc2015\\7.txt', { encoding: 'utf8' });
const parsedInput = parse(input);

// part 1
const signalA = evaluator.evaulateVariable('a', parsedInput);
console.log(signalA);

// part 2
evaluator.resetEvaulator();
parsedInput['b'] = { lhs: signalA };
console.log(evaluator.evaulateVariable('a', parsedInput));