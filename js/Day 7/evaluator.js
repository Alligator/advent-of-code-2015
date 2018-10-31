const and = (a, b) => a & b;
const or = (a, b) => a | b;
const lshift = (a, b) => a << b;
const rshift = (a, b) => a >>> b;
const not = a => ~a;

let memo = {};
const resetEvaulator = () => {
  memo = {};
};

const evaulateVariable = (variable, bindings) => {
  if (typeof memo[variable] === 'number') {
    return memo[variable];
  }

  // case where it's just a value
  if (typeof variable === 'number') {
    return variable;
  }

  const expr = bindings[variable];
  let opFunc;
  let result;

  switch (expr.op) {
    // 2 arg opcodes
    case 'AND':     opFunc = opFunc || and;
    case 'OR':      opFunc = opFunc || or;
    case 'LSHIFT':  opFunc = opFunc || lshift;
    case 'RSHIFT':  opFunc = opFunc || rshift;
    {
      const left = evaulateVariable(expr.lhs, bindings);
      const right = evaulateVariable(expr.rhs, bindings);
      result = opFunc(left, right);
      break;
    }

    // 1 arg opcodes
    case 'NOT': {
      const right = evaulateVariable(expr.rhs, bindings);
      result = not(right);
      break;
    }

    default: {
      // no opcode, must just be a variable
      result = evaulateVariable(expr.lhs, bindings);
      break;
    }
  }

  // mask off all but the bottom 16 bits
  result &= 0xFFFF;
  memo[variable] = result;
  return result;
};

module.exports = {
  evaulateVariable,
  resetEvaulator,
};