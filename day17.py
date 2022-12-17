input_file = "./inputs/day17ex.txt"

rocks = [
    [[1, 1, 1, 1]],
    [[0, 1, 0], [1, 1, 1], [0, 1, 0]],
    [[0, 0, 1], [0, 0, 1], [1, 1, 1]],
    [[1], [1], [1], [1]],
    [[1, 1], [1, 1]],
]


def parse():
    with open(input_file) as file:
        return list(file.readlines().pop().strip())


wind = parse()
room = []
for _ in range(0, 3):
    r = []
    for _ in range(0, 7):
        r.append(0)
    room.append(r)

# for _ in range(0, 2022):


