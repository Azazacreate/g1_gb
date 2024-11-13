a1 = 2
d = 3
n = 4
list_1 = []


for i in range(n):
    a = a1 + (n-1-i) * d
    list_1.append(a)
for i in range(1, n):
    print(list_1[-i])
print(a1 + (n-1) * d)


