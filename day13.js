let fs = require("fs");
let log = console.log;

let inputFile = "./inputs/day13.txt";

let isN = (a) => typeof a === "number";
let isArr = Array.isArray;

let cmp = (l, r) => {
  if (isN(l) && isN(r)) {
    if (l === r) return null;
    return l < r;
  }

  // one is not a number so transform both to arr
  if (isN(l)) {
    l = [l];
  }
  if (isN(r)) {
    r = [r];
  }

  let i;
  for (i = 0; i < Math.min(r.length, l.length); i++) {
    let res = cmp(l[i], r[i]);
    if (res === null) {
      continue;
    }
    return res;
  }

  if (i === r.length && r.length < l.length) return false;
  if (r.length === l.length) return null

  return true;
};

let input = fs
  .readFileSync(inputFile)
  .toString()
  .trim()
  .split("\n\n")
  .map((pairs) => pairs.split("\n").map((l) => JSON.parse(l)));

let sum = 0;
for (let i = 0; i < input.length; i++) {
  let [left, right] = input[i];

  if (cmp(left, right)) {
    sum += i + 1;
  }
}

log(sum);
