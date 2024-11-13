"""Простейшие анонимные функции"""
from sys import getsizeof


def func(p_1, p_2):
    return p_1 + p_2


res = func(20, 30)
print(res)
print(getsizeof(func))

res = lambda p_1, p_2: p_1 + p_2
print(getsizeof(res))
print(res(1, 2))
