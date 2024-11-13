# list_1 = [1, 3, 3, 3, 4]  # 1 3 3 3 1
# max_1 = list_1[0]
# min_1 = list_1[0]
# list_2 = []
# for el in list_1:
#     if el > max_1:
#         max_1 = el
#     if el < min_1:
#         min_1 = el
# for el in list_1:
#     if el == max_1:
#         list_2.append(min_1)
#     else:
#         list_2.append(el)
# print(min_1, max_1)
# print(list_2)

# 2.2
# list_1 = [1, 3, 3, 3, 4]  # 1 3 3 3 1
# max_1 = max(list_1)
# min_1 = min(list_1)
# list_2 = []
# for el in list_1:
#     if el == max_1:
#         list_2.append(min_1)
#     else:
#         list_2.append(el)
# print(list_2)

# 2.3 comprehension
# print([min_1 if el == max_1 else el for el in list_1])


# 2.4_recursion
list_1 = [1, 3, 3, 3, 4]
def func_1(list_1, max_1=max(list_1), min_1=min(list_1), list_2=[]):
    if len(list_1) == 0:
        return list_2
    if list_1[0] == max_1:
        list_2.append(min_1)
    else:
        list_2.append(list_1[0])
    return func_1(list_1[1:], max_1, min_1, list_2)


print(func_1(list_1))


# 2.5
list_1 = [1, 3, 3, 3, 4]
def func_1(list_1, list_2=[], max_1=max(list_1), min_1=min(list_1)):
    if len(list_1) == 0:
        return list_2
    if list_1[0] == max_1:
        list_2.append(min_1)
    else:
        list_2.append(list_1[0])
    return func_1(list_1[1:], list_2)


print(func_1(list_1))