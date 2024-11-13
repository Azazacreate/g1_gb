#1
# from sys import argv
#
# script_name, first_param, second_param, third_param = argv
#
# print("Имя скрипта: ", script_name)
# print("Параметр 1: ", first_param)
# print("Параметр 2: ", second_param)
# print("Параметр 3: ", third_param)


#2 Метод strip() по умолчанию убирает пробелы в начале и в конце строки
# lines = [line.strip() for line in open('text.txt')]
# print(lines)


#3 Генераторы словарей и множеств
# my_dict = {round(el*1.1): el*2 for el in range(10, 20)}
# print(my_dict)


#4 генератор псевдослучайных чисел
# from random import randrange
# print(randrange(2))         # 0 OR 1


#5
# a = ['id', 'date', 'price', 'bedrooms', 'bathrooms', 'sqft_living',
#        'sqft_lot', 'floors', 'waterfront', 'view', 'condition', 'grade',
#        'sqft_above', 'sqft_basement', 'yr_built', 'yr_renovated', 'zipcode',
#        'lat', 'long', 'sqft_living15', 'sqft_lot15']
# print(*a)


#6
# def generator():
#     for el in (10, 20, 30):
#         yield el
# g = generator()
# print(g)
# for el in g:
#     print(el)


#7 reduce()
# from functools import reduce
# def my_func(prev_el, el):
#     # prev_el - предыдущий элемент
#     # el - текущий элемент
#     return prev_el + el
# print(reduce(my_func, [10, 20, 30]))


#8 partial()
# from functools import partial
#
# def my_func(param_1, param_2):
#     return param_1 ** param_2
#
# new_my_func = partial(my_func, 2)
# print(new_my_func)
# print(new_my_func(4))


#9
# from itertools import count
#
# for el in count(7):
#     if el > 15:
#         break
#     else:
#         print(el)


#10 cycle()
from itertools import cycle
#
# с = 0
# for el in cycle("ABC"):
#     if с > 10:
#         break
#     print(el)
#     с += 1


#11
# from itertools import cycle
#
# progr_lang = ["python", "java", "perl", "javascript"]
# iter = cycle(progr_lang)
#
# print(next(iter))
# print(next(iter))
# print(next(iter))
# print(next(iter))
# print(next(iter))
# print(next(iter))