#1
"""
1.	Реализовать скрипт, в котором должна быть предусмотрена функция расчёта заработной платы сотрудника. Используйте в нём формулу: (выработка в часах*ставка в час) + премия. Во время выполнения расчёта для конкретных значений необходимо запускать скрипт с параметрами.
"""


# from sys import argv
# script_name, first_param, second_param, third_param = argv
# print("Имя скрипта: ", script_name)
# print("Параметр 1: ", first_param)
# print("Параметр 2: ", second_param)
# print("Параметр 3: ", third_param)


#1.2
# from sys import argv
# script_name, first_param, second_param, third_param = argv
# print("Имя скрипта: ", script_name)
# print((int(first_param) * int(second_param)) + int(third_param))
# launch in-Terminal
# python3 p4_practik.py 1 2 3


#2
# list_1 = [300, 2, 12, 44, 1, 1, 4, 10, 7, 1, 78, 123, 55]
#     # [12, 44, 4, 10, 78, 123]
# list_2 = [list_1[el] for el in range(1, len(list_1)) if list_1[el] > list_1[el-1]]
# print(list_2)


#3
# print([el for el in range(20, 241) if el % 20 == 0 or el % 21 == 0])


#4
# list_1 = [2, 2, 2, 7, 23, 1, 44, 44, 3, 2, 10, 7, 4, 11]
# print([el for el in list_1 if list_1.count(el) < 2])


#5
# from functools import reduce
# print(reduce(lambda a1, a2: a1 * a2, [el for el in range(100, 1001) if el % 2 == 0]))


#6      python3 p4_practik.py 2 3 4    terminal
# from sys import argv
# from itertools import count
# from itertools import cycle
# script_name, a1, a2, a3 = argv
#
#
# # 6.2 count()
# list_1 = []
# for el in count(int(a1)):
#     if el > 10:
#         break
#     list_1.append(el)
# print(list_1)
#
#
# # 6.3 cycle()
# b = 0
# for el in cycle("list_elements"):
#     if b > 10:
#         break
#     print(el)
#     b += 1


#7
from math import factorial
print(factorial(5))


def fact(n=4):
    for el in range(1, n+1):
        yield el


from functools import reduce
print(reduce(lambda a1, a2: a1 * a2, [el for el in fact(6)]))


# The-end.