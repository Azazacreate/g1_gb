"""
Функция reduce()
Она применяет указанную функцию к некоторому набору объектов
и сводит его к единственному значению.
"""

from functools import reduce


def my_func(prev_el, el):
    # prev_el - предыдущий элемент
    # el - текущий элемент
    print(f'{prev_el}, {el}')
    return prev_el + el


print(reduce(my_func, (10, 20, 30, 40)))  # -> 60
