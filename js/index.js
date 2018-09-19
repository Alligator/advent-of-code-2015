const fs = require('fs');

const inp = fs.readFileSync('1.txt', 'utf8');

// part 1
// 62 characters
function f(a){for(i=0,k=0;k+=a[i++]=='('?1:-1,a[i];);return k}

console.assert(f('(())') === 0);
console.assert(f('(()(()(') === 3);
console.assert(f('))(((((') === 3);
console.assert(f('))(') === -1);
console.assert(f(')())())') === -3);
console.log(f(inp));

// part 2
// 76 characters
function g(a){for(i=0,k=0,d=0;k+=a[i++]=='('?1:-1,d=k<0,a[i]&&!d;);return i}

console.assert(g(')') === 1);
console.assert(g('()())') === 5);
console.log(g(inp));