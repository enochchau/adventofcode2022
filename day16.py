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


if __name__ == "__main__":
    input_file = "./inputs/day16.txt"
    rates: dict[str, int] = {}
    adj: AdjMatrix = {}
    with open(input_file) as file:
        for line in file.readlines():
            valvs = re.findall("[A-Z]{2}", line)
            valvs.reverse()
            valv = valvs.pop()
            adj[valv] = valvs
            rates[valv] = int(re.findall("\\d+", line).pop())

    # current location
    loc = "AA"
    time_left = 30
    open_valv_rates: list[int] = []
    pressure = 0

    # we need to assign every node a weight based on valv_val
    # 1. find the # of steps from current loc to next valv
    # 2. calc each valv value and choose highest value
    # 3. decrement time by amount needed to open that valv
    # -> during this process, track pressure released


    # we need to explore every none-zero possibility and then choose the one 
    # with the highest pressure release

    while time_left > 0:
        next_loc = loc
        next_val = 0
        next_cost = 0

        v = {}
        for k in rates:
            dist = find_steps(adj, loc, k, 0, set())
            val = valv_val(time_left, dist, rates[k])
            v[k] = (val, rates[k], dist + 1)
            if val > next_val:
                next__val = val
                next_loc = k
                next_cost = dist + 1

        print(v)
        break
