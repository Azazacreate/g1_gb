from functools import reduce
count_words = 1
with open("m3.txt", "r") as a1:
    a2 = a1.read().split("\n")
    a5 = []
    for line in a2:
        a3 = line.split()
        a4 = float(a3[1])
        if a4 < 20000:
            print(a3[0])
        a5.append(a4)
    print("")
    print(int(reduce(lambda x1, x2: x1 + x2, a5) / len(a2)))
