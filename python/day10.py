from itertools import groupby, islice

def gen(s):
  current = s
  while True:
    yield current
    current = ''.join(str(len(list(items))) + char for (char, items) in groupby(current))

def faster_gen(s):
  current = bytearray(s)
  while True:
    yield current
    groups = groupby(current)
    nxt = bytearray()
    for digit, items in groups:
      nxt.append(len(list(items)))
      nxt.append(digit)
    current = nxt

# def bingen(s):
#   current = bytearray(s)
#   while True:
#     yield current
#     groups = groupby(current)
#     nxt = bytearray()
#     for i, (digit, items) in enumerate(groups):
#       nxt.append(len(list(items)))
#       nxt.append(digit)
#     current = nxt
# g = bingen(bytes([0x01]))

# part1 = next(islice(g, 40, 41))
# print(len(part1))

# part2 = next(islice(g, 50, 51))
# print(len(part2)

# g = gen('1113122113')
g = faster_gen([0x1, 0x1, 0x1, 0x3, 0x1, 0x2, 0x2, 0x1, 0x1, 0x3])

for i, r in enumerate(islice(g, 51)):
  l = len(r)
  print('{} {}'.format(i, l))