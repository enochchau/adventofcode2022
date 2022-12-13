let fs = require("fs");
let inputFile = "./inputs/day11ex.txt";
let log = console.log;

let buildOp = (op, opVal) => (old) => {
  if (isNaN(opVal)) opVal = old;
  if (op === "+") {
    return opVal + old;
  }
  return opVal * old;
};

let buildTest = (test, pass, fail) => (old) => {
  if (old % test === 0) {
    return pass;
  }
  return fail;
};

function part1() {
  let lines = fs.readFileSync(inputFile).toString().split("\n");

  let monkeys = [];

  for (let i = 0; i < lines.length; i += 7) {
    let index = parseInt(lines[i].match(/\d+/)[0]);
    let items = lines[i + 1].match(/\d+/g).map((str) => parseInt(str));
    let opM = lines[i + 2].match(/old (\*|\+) (\d+|old)/);
    let op = opM[1];
    // if isNaN then use 'old'
    let opVal = parseInt(opM[2]);

    let test = parseInt(lines[i + 3].match(/\d+/)[0]);

    let pass = parseInt(lines[i + 4].match(/\d+/)[0]);
    let fail = parseInt(lines[i + 5].match(/\d+/)[0]);

    monkeys.push({
      items,
      op,
      opVal,
      test,
      pass,
      fail,
      count: 0,
    });
  }

  for (let i = 0; i < 20; i++) {
    monkeys.forEach((monkey, mI) => {
      let len = monkey.items.length;
      for (let j = 0; j < len; j++) {
        let worry = monkey.items.shift();

        log({mI})
        log("before", worry);

        worry = buildOp(monkey.op, monkey.opVal)(worry);
        worry = Math.floor(worry / 3);
        let next = buildTest(monkey.test, monkey.pass, monkey.fail)(worry);
        monkeys[next].items.push(worry);
        monkey.count += 1;

        log("after", { worry, next });
      }
    });
  }
  let max = monkeys.map((m) => m.count).sort();
  log(max[0] * max[1]);
}

part1();
