"""Стандартная сортировка"""

from random import randint
from timeit import timeit


def reverse_sort(lst_obj):
    lst_obj.sort()
    return orig_list


orig_list = [randint(-100, 100) for _ in range(10)]

# замеры 10
print(
    timeit(
        "reverse_sort(orig_list[:])",
        globals=globals(),
        number=1000))

orig_list = [randint(-100, 100) for _ in range(100)]

# замеры 100
print(
    timeit(
        "reverse_sort(orig_list[:])",
        globals=globals(),
        number=1000))

orig_list = [randint(-100, 100) for _ in range(1000)]

# замеры 1000
print(
    timeit(
        "reverse_sort(orig_list[:])",
        globals=globals(),
        number=1000))

"""
0.0003924000000000011
0.005301399999999998
0.092812
"""

"""
0.00031299999999999384
0.0006287000000000098
0.0020312999999999998
"""
