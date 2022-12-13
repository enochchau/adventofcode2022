const assert = require("node:assert");
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

const canMove = (m, row, col, nRow, nCol) => m[nRow][nCol] - m[row][col] <= 1;

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

let q = [start];
let seen = new Set();
let costs = Object.keys(adj).reduce((acc, k) => {
  acc[k] = Infinity;
  return acc;
}, {});
costs[start] = 0;

while (q.length > 0) {
  let point = q.shift();
  let cost = costs[point];

  if (point === end) {
    break;
  }

  seen.add(point);

  let needsSort = false;
  for (const next of adj[point]) {
    if (!seen.has(next) || costs[next] > cost + 1) {
      q.push(next);
      costs[next] = cost + 1;
      needsSort = true;
    }
  }

  if (needsSort)
    q.sort((a, b) => {
      if (costs[a] > costs[b]) return 1;
      if (costs[a] < costs[b]) return -1;
      return 0;
    });
}

log(costs);
log("end", end);
log("end costs", costs[end]);
