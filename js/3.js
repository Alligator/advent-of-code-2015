const fs = require('fs');
const path = require('path');

const input = fs.readFileSync(path.join(__dirname, '..', '3.txt'), { encoding: 'utf8' });
const visited = {};
let x = 0;
let y = 0;

visited[`${x},${y}`] = 1;

input.split('').forEach((dir) => {
  switch (dir) {
    case '<': x--; break;
    case '>': x++; break;
    case '^': y++; break;
    case 'v': y--; break;
  }

  const key = [`${x},${y}`];

  if (visited[key]) {
    visited[key]++;
  } else {
    visited[key] = 1;
  }
});

console.log(Object.keys(visited).length);