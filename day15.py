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


def part2(lines, xmax: int, ymax: int):
    coverage: list[list[dict[str, int]]] = []
    # coverage = list[tuple[int, int, int, int]]
    for y in range(0, ymax + 1):
        coverage.append([])

    for l in lines:
        sx, sy, bx, by = l
        dist = m_dist(sx, sy, bx, by)

        for y in range(0, ymax + 1):
            y_dist = abs(sy - y)
            x_dist = dist - y_dist
            if x_dist >= 0:
                coverage[y].append(
                    {"min": max(sx - x_dist, 0), "max": min(sx + x_dist, xmax)}
                )
    print("fin coverage")

    for i, y_cov in enumerate(coverage):
        print("-> y = ", i)
        x_possible = set()
        for n in range(0, xmax + 1):
            x_possible.add(n)

        for x_cov in y_cov:
            for x in range(x_cov["min"], x_cov["max"] + 1):
                if x in x_possible:
                    x_possible.remove(x)

        l_xp = list(x_possible)
        if len(l_xp) > 0:
            print("part2 freq:", l_xp[0] * 4000000 + i)
            break


if __name__ == "__main__":
    lines = parse(input_file)
    # part1(lines)
    part2(lines, 4000000, 4000000)

    # lines = parse(input_fileex)
    # part2(lines, 20, 20)
