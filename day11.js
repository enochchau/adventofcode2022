let fs = require("fs");
let inputFile = "./inputs/day11.txt";
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

// lets get some code from stack overflow
function gcd(a,b){
  var t = 0;
  a < b && (t = b, b = a, a = t); // swap them if a < b
  t = a%b;
  return t ? gcd(b,t) : b;
}

function lcm(a,b){
  return a/gcd(a,b)*b;
}

function part2() {
  let monkeys = parse();
  let rounds = 10000;
  let LCM = monkeys.map(m => m.test.divisor).reduce((acc, item) => lcm(acc, item))

  for (let i = 0; i < rounds; i++) {
    monkeys.forEach((monkey) => {
      while (monkey.items.length) {
        let old = monkey.items.shift();
        let item = runInspect(old, monkey.op);
        monkey.business += 1;

        item = item % LCM

        let next = getNext(item, monkey.test);

        monkeys[next].items.push(item);
      }
    });
  }
  log("part2", getAns(monkeys));
}

// part1()
part2();
