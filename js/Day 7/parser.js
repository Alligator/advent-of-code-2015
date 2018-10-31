const parse = (input) => {
  const regex = new RegExp(/^([a-z]+|\d+)? ?(AND|OR|LSHIFT|RSHIFT|NOT)? ?([a-z]+|\d+)? -> ([a-z]+)/);
  const output = {};

  input.trim().split('\n').forEach((line) => {
    const matches = regex.exec(line);

    const lhs = matches[1];
    const intLhs = parseInt(lhs);
    const op = matches[2];
    const rhs = matches[3];
    const intRhs = parseInt(rhs);
    const variable = matches[4];

    output[variable] = {
      op,
      lhs: isNaN(intLhs) ? lhs : intLhs,
      rhs: isNaN(intRhs) ? rhs : intRhs,
    };
  });

  return output;
};

module.exports = parse;