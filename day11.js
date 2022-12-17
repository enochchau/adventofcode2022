let fs = require("fs");
let inputFile = "./inputs/day11ex.txt";
let log = console.log;

function parse() {
  return fs
    .readFileSync(inputFile)
    .toString()
    .trim()
    .split("\n")
    .reduce((sevens, line, i) => {
      if (i % 7 === 0) {
        sevens.push([]);
      }
      sevens[sevens.length - 1].push(line);
      return sevens;
    }, [])
    .map((seven) => {
      let items = Array.from(seven[1].matchAll(/\d+/g)).map((m) =>
        parseInt(m[0])
      );

      let op = {
        op: seven[2].match(/[+*]/)[0],
        val: parseInt(seven[2].match(/(old|\d+)$/)[0]),
      };

      let test = {
        divisor: parseInt(seven[3].match(/\d+/)[0]),
        pass: parseInt(seven[4].match(/\d+/)[0]),
        fail: parseInt(seven[5].match(/\d+/)[0]),
      };
      return {
        items,
        op,
        test,
        business: 0,
      };
    });
}

const runInspect = (old, op) => {
  let val = isNaN(op.val) ? old : op.val;
  if (op.op === "*") {
    return old * val;
  } else {
    // +
    return old + val;
  }
};

const releif = (item) => {
  return Math.floor(item / 3);
};

const getNext = (item, test) => {
  if (item % test.divisor) {
    return test.fail;
  }
  return test.pass;
};

const getAns = (monkeys) => {
  let [m1, m2] = monkeys.sort((a, b) => b.business - a.business);
  return m1.business * m2.business;
};

function part1() {
  let monkeys = parse();
  for (let i = 0; i < 20; i++) {
    monkeys.forEach((monkey) => {
      while (monkey.items.length) {
        let old = monkey.items.shift();
        let item = runInspect(old, monkey.op);
        monkey.business += 1;
        item = releif(item);
        let next = getNext(item, monkey.test);
        monkeys[next].items.push(item);
      }
    });
  }
  log("part1", getAns(monkeys));
}

function part2() {
  let monkeys = parse();
  let rounds = 20; // 10000;
  for (let i = 0; i < rounds; i++) {
    monkeys.forEach((monkey) => {
      while (monkey.items.length) {
        let old = monkey.items.shift();
        let item = runInspect(old, monkey.op);
        monkey.business += 1;

        let next;
        let mod = item % monkey.test.divisor;
        if (mod) {
          next = monkey.test.fail;
        } else {
          next = monkey.test.pass;
          item = item % monkey.test.divisor;
        }

        monkeys[next].items.push(item % monkey.test.divisor);
      }
    });
  }
  log(monkeys);
  log("part2", getAns(monkeys));
}

// part1()
part2();
