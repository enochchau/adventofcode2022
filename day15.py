import re


if __name__ == "__main__":
    input_file = "./inputs/day15.txt"
    y_goal = 2000000
    coverage = set()
    lines: list[tuple[int, int, int, int]] = []

    with open(input_file) as file:
        for line in file.readlines():
            sx, sy, bx, by = list(map(lambda x: int(x), re.findall("-?\\d+", line)))
            lines.append((sx, sy, bx, by))

    for l in lines:
        sx, sy, bx, by = l

        # get manhatten distance
        distance = abs(sx - bx) + abs(sy - by)

        y_dist = abs(sy - y_goal) # from sy move up y_dist
        x_dist = distance - y_dist
        if x_dist >= 0:
            for x in range(sx - x_dist, sx + x_dist + 1):
                if (bx, by) != (x, y_goal):
                    coverage.add(x)

    print(len(coverage))
