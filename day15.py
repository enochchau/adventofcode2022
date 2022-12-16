import re

input_file = "./inputs/day15.txt"
input_fileex = "./inputs/day15ex.txt"


def parse(input_file) -> list[tuple[int, int, int, int]]:
    lines: list[tuple[int, int, int, int]] = []
    with open(input_file) as file:
        for line in file.readlines():
            sx, sy, bx, by = list(map(lambda x: int(x), re.findall("-?\\d+", line)))
            lines.append((sx, sy, bx, by))

    return lines


def m_dist(sx, sy, bx, by) -> int:
    return abs(sx - bx) + abs(sy - by)


def part1(lines):
    y_goal = 2000000
    coverage = set()

    for l in lines:
        sx, sy, bx, by = l

        # get manhatten distance
        distance = m_dist(sx, sy, bx, by)

        y_dist = abs(sy - y_goal)  # from sy move up y_dist
        x_dist = distance - y_dist
        if x_dist >= 0:
            for x in range(sx - x_dist, sx + x_dist + 1):
                if (bx, by) != (x, y_goal):
                    coverage.add(x)

    print("part1", len(coverage))


def check_point(lines, x, y):
    found = True
    for l in lines:
        sx, sy, bx, by = l
        distance = m_dist(sx, sy, bx, by)

        d = m_dist(sx,sy, x, y)
        found = found and d > distance

        if not found:
            return found

    return found

def freq(x,y):
    return x * 4000000 + y

def part2(lines, bound: int):
    # we only have to check the points just outside the bounds

    for l in lines:
        sx, sy, bx, by = l
        distance = m_dist(sx, sy, bx, by)

        for y in range(max(sy - distance, 0), min(sy + distance, bound) + 1):
            y_dist = abs(sy - y)
            x_dist = distance - y_dist
            # check just outside x low and x high
            xlow = sx - x_dist - 1
            if xlow >= 0 and xlow <= bound:
                if check_point(lines, xlow, y):
                    return freq(xlow, y)

            xhigh = sx + x_dist + 1
            if xhigh >= 0 and xhigh <= bound:
                if check_point(lines, xhigh, y):
                    return freq(xhigh, y)




if __name__ == "__main__":

    lines = parse(input_fileex)
    sol = part2(lines, 20)
    print('part2 ex', sol)


    lines = parse(input_file)
    # part1(lines)
    sol = part2(lines, 4000000)
    print("part2", sol)

