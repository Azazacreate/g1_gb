"""
5. Реализовать формирование списка, используя функцию range()
и возможности LC.
В список должны войти четные числа от 100 до 1000 (включая границы).
Необходимо получить результат вычисления произведения всех элементов списка.
Подсказка: использовать лямбда-функцию и функцию reduce().
"""

from functools import reduce

primary_list = [x for x in range(100, 1001, 2)]

print(primary_list)

res = reduce(lambda item, item2: item * item2, primary_list)

print(f"Результат: {res}")
