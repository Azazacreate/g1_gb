s = 12          # x + y
p = 27          # x * y
for i in range(1000):
    for j in range(1000):
        if i + j == s and i * j == p:
            print(i, j)
