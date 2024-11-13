# list_1 = [3, 1, 3, 4, 2, 4, 12]
# list_2 = [4, 15, 43, 1, 15, 1]
# list_3 = []
# for el in list_1:
# 	if el not in list_2:
# 		list_3.append(el)
# print(*list_3)


# 1.2 list comprehension
# list_1 = [3, 1, 3, 4, 2, 4, 12]
# list_2 = [4, 15, 43, 1, 15, 1]
# list_4 = [el for el in list_1 if el not in list_2]
# print(*list_4)


# 1.3_filter and lambda
# list_5 = list(filter(lambda el: el not in list_2, list_1))
# print(list_5)
...


# 1.4 map()
# num_6 = list(map(int, input("Input your numbers separated by-spaces").split()))
# print(num_6)


# 1.5_recursion
# list_1 = [3, 1, 3, 4, 2, 4, 12]
# list_2 = [4, 15, 43, 1, 15, 1]
# list_3 = []
# for el in list_1:
# 	if el not in list_2:
# 		list_3.append(el)
# print(*list_3)


def func_5(
        list_1=[3, 1, 3, 4, 2, 4, 12],
        list_2=[4, 15, 43, 1, 15, 1],
        list_3=[]
):
    if len(list_1) == 0:
        return list_3
    if list_1[0] not in list_2:
        list_3.append(list_1[0])
    return func_5(list_1[1:], list_2, list_3)


print(func_5())
