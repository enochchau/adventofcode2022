const fs = require("fs");

let intputFile = "./inputs/day12.txt";

let log = console.log;

let S = "S".charCodeAt(0);
let E = "E".charCodeAt(0);

const find = (cCode) => (m) => {
  for (let i = 0; i < m.length; i++) {
    for (let j = 0; j < m[i].length; j++) {
      if (m[i][j] === cCode) return `${i},${j}`;
    }
  }
};

const fix = (m, pointStr, c) => {
  let [row, col] = pointStr.split(",").map((c) => parseInt(c));
  m[row][col] = c.charCodeAt(0);
};

const findStart = find(S);
const findEnd = find(E);

const inBounds = (m, row, col) =>
  row >= 0 && row < m.length && col >= 0 && col < m[row].length;

const canMove = (m, row, col, nRow, nCol) =>
  Math.abs(m[row][col] - m[nRow][nCol]) <= 1;

// ----
let input = fs.readFileSync(intputFile).toString();

let m = input
  .trim()
  .split("\n")
  .map((s) => s.split("").map((c) => c.charCodeAt(0)));

let start = findStart(m);
fix(m, start, "a");

let end = findEnd(m);
fix(m, end, "z");

let adj = {};

for (let row = 0; row < m.length; row++) {
  for (let col = 0; col < m[row].length; col++) {
    adj[`${row},${col}`] = [];
    [
      [row + 1, col],
      [row - 1, col],
      [row, col + 1],
      [row, col - 1],
    ].forEach(([nRow, nCol]) => {
      if (inBounds(m, nRow, nCol) && canMove(m, row, col, nRow, nCol)) {
        adj[`${row},${col}`].push(`${nRow},${nCol}`);
      }
    });
  }
}

let q = [{ point: end, step: 0 }];
let seen = new Set();

while (q.length) {
  let { point, step } = q.shift();
  seen.add(point);
  if (point === start) {
    log(step)
    break;
  }

  adj[point].forEach((next) => {
    if (seen.has(next)) return;
    q.push({ point: next, step: step + 1 });
  });
}
