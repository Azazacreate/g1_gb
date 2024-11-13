with open("m5.txt", "a") as a1:
    a1.write("1 2 3 4 5 6 7\n")
with open("m5.txt", "r") as a1:
    a2 = sum(map(int, a1.read().split()))
    print(a2)