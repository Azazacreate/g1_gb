# way-1         Работает
# list_1 = [1, 2, 3, 5, 8, 15, 23, 38]
# list_2 = []
# for i in list_1:
#     if i % 2 == 0:
#     	list_2.append((i, i ** 2))
# print(list_2)


# way-2
# def select_1(func, val_1):
#     return [func(x) for x in val_1]
# def where_2(func, val_1):
#     return [x for x in val_1 if func(x)]
# list_1 = [1, 2, 3, 5, 8, 15, 23, 38]
# list_2 = select_1(int, list_1)
# print(list_2)
# list_2 = where_2(lambda x: x % 2 == 0, list_2)
# print(list_2)
# list_2 = list(select_1(lambda x:(x, x**2), list_2))
# print(list_2)


# way-3
# list_1 = [1, 2, 3, 5, 8, 15, 23, 38]
# list_2 = []
# list(map(lambda x: list_2.append(x) if x % 2 == 0 else None, list_1))
# print(*list(map(lambda y: (y, y*2), list_2)))


# way-4
list_1 = [1, 2, 3, 5, 8, 15, 23, 38]
list_2 = []
print(*list(map(lambda y: (y, y*2), list(filter(lambda x: x % 2 == 0, list_1)))))