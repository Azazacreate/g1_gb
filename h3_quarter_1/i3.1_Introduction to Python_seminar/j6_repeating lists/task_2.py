list_1 = [1, 5, 1, 5, 1]
count = 0
for el in range(1, len(list_1)-1):
    if list_1[el] > list_1[el-1] and list_1[el] > list_1[el+1]:
        count += 1
print(count)
