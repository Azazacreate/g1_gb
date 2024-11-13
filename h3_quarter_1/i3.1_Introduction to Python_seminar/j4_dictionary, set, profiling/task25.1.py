str1 = "a a a b c a a d c d d".split()
dict1 = {}
for i in str1:
    if i in dict1:
        dict1[i] += 1
        print(f"{i}_{dict1[i]}", end=" ")
    else:
        dict1[i] = 0
        print(i, end=" ")
print("\n", dict1)