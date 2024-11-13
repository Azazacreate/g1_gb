"""
coins = [0, 1, 0, 1, 1, 0]
3
"""


coins = [0, 0, 1, 0, 1, 1, 1, 0]
orel = reshka = 0
for i in coins:
    if i == 0:
        orel += 1
    else:
        reshka += 1


if orel <= reshka:
    print(orel)
else:
    print(reshka)