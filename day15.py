import re


def m_dist(sx, sy, ex, ey) -> int:
    return abs(sx - ex) + abs(sy - ey)


if __name__ == "__main__":
    input_file = "./inputs/day15.txt"
    y_goal = 2000000
    coverage = set()

    with open(input_file) as file:
        for line in file.readlines():

            sx, sy, bx, by = list(map(lambda x: int(x), re.findall("\\d+", line)))
            distance = m_dist(sx, sy, bx, by)

            y_dist = abs(sy - y_goal)
            x_dist = distance - y_dist
            if x_dist >= 0:
                for x in range(sx - x_dist, sx + x_dist + 1):
                    if (bx, by) == (x, y_goal):
                        continue
                    coverage.add(x)

    print(len(coverage))
