const fs = require("fs");

let intputFile = "./inputs/day12ex.txt";

let log = console.log;

function hash([x, y]) {
  return `${x},${y}`;
}

function canMove(matrix, [x, y], [nextX, nextY]) {
  let inBounds =
    nextX >= 0 &&
    nextX < matrix.length &&
    nextY >= 0 &&
    nextY < matrix[0].length;

  if (!inBounds) return false;

  let curr = matrix[x][y];
  let next = matrix[nextX][nextY];

  return next - curr <= 1;
}

function parse() {
  let matrix = fs
    .readFileSync(intputFile)
    .toString()
    .trim()
    .split("\n")
    .map((l) => l.split(""));

  let start,
    end,
    allStarts = [];

  for (let [x, row] of Object.entries(matrix)) {
    x = parseInt(x);
    for (let [y, p] of Object.entries(row)) {
      y = parseInt(y);
      if (p === "S") {
        matrix[x][y] = "a";
        start = [x, y];
        allStarts.push(start);
      }
      if (p === "E") {
        matrix[x][y] = "z";
        end = [x, y];
      }
      if (p === "a") {
        allStarts.push([x, y]);
      }
      matrix[x][y] = matrix[x][y].charCodeAt(0) - 97;
    }
  }

  return [matrix, start, end, allStarts];
}

function findSteps(matrix, start, end) {
  let endHash = hash(end);

  let steps = Array(matrix.length)
    .fill(null)
    .map(() =>
      Array(matrix[0].length)
        .fill(null)
        .map(() => Infinity)
    );
  steps[start[0]][start[1]] = 0;
  let q = [start];
  let seen = new Set([hash(start)]);

  while (q.length) {
    let node = q.shift();

    let [x, y] = node;
    let step = steps[x][y];

    let nodeHash = hash(node);

    if (nodeHash === endHash) {
      break;
    }

    [
      [x + 1, y],
      [x - 1, y],
      [x, y + 1],
      [x, y - 1],
    ].forEach((next) => {
      if (seen.has(hash(next))) return;
      let move = canMove(matrix, node, next);
      if (!move) return;

      let [nx, ny] = next;
      steps[nx][ny] = Math.min(step + 1, steps[nx][ny]);
      seen.add(hash(next));
      q.push(next);
    });

    q.sort(([ax, ay], [bx, by]) => steps[ax][ay] - steps[bx][by]);
  }

  return steps;
}

function part1() {
  let [matrix, start, end] = parse();
  let endHash = hash(end);

  let steps = findSteps(matrix, start, end);

  log("part1", steps[end[0]][end[1]]);
}
// part1();

function part2() {
  let [matrix, _, end, allStarts] = parse();

  let lowest = Math.min(
    ...allStarts.map((start) => {
      let steps = findSteps(matrix, start, end);
      return steps[end[0]][end[1]];
    })
  );
  log("part2", lowest);
}
part2();
