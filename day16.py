import re

inf = 9000000000000000

AdjMatrix = dict[str, list[str]]

# the value of a valv is
# value = (time_left - steps - turn_time) * rate
# steps = number of hops from current location to valv
# turn_time = 1
def valv_val(time_left: int, steps: int, rate: int):
    return (time_left - steps - 1) * rate


def find_steps(adj: AdjMatrix, curr: str, end: str, steps: int, seen: set[str]):
    if curr == end:
        return steps

    seen.add(curr)

    next_steps = [inf]
    for next in adj[curr]:
        if not next in seen:
            next_steps.append(find_steps(adj, next, end, steps + 1, seen))

    return min(next_steps)

def calc_pressure(open_valvs: list[int], pressure: int, cost: int):
    next_pressure = pressure
    for p in open_valvs:
        next_pressure += p * cost
    return next_pressure

def explore(adj: AdjMatrix, rates, loc: str, time_left: int, open_valvs: list[int], pressure: int):
    if time_left == 0:
        return pressure


    found = [0]
    for k in rates:
        steps = find_steps(adj, loc, k, 0, set())
        val = valv_val(time_left, steps, rates[k])
        cost = steps + 1

        if val > 0:
            if time_left - cost <= 0:
                next_pressure = calc_pressure(open_valvs, pressure, 1)
                f = explore(adj, rates, k, time_left - 1, open_valvs, next_pressure)
                found.append(f)
            else:
                next_valvs = open_valvs.copy()
                next_valvs.append(rates[k])
                next_pressure = calc_pressure(open_valvs, pressure, cost)
                f = explore(adj, rates, k, time_left - cost, next_valvs, next_pressure)
                found.append(f)
    return max(found)


if __name__ == "__main__":
    input_file = "./inputs/day16ex.txt"
    rates: dict[str, int] = {}
    adj: AdjMatrix = {}
    with open(input_file) as file:
        for line in file.readlines():
            valvs = re.findall("[A-Z]{2}", line)
            valvs.reverse()
            valv = valvs.pop()
            adj[valv] = valvs
            rates[valv] = int(re.findall("\\d+", line).pop())

    # we need to assign every node a weight based on valv_val
    # 1. find the # of steps from current loc to next valv
    # 2. calc each valv value and choose highest value
    # 3. decrement time by amount needed to open that valv
    # -> during this process, track pressure released

    # we need to explore every none-zero possibility and then choose the one
    # with the highest pressure release

    # This probably has some dynamic programming involved to cache previous steps?

    print("part1", explore(adj, rates, "AA", 30, [], 0))
