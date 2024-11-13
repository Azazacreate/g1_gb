"""
2. Представлен список чисел. Необходимо вывести элементы исходного списка,
значения которых больше предыдущего элемента.
Подсказка: элементы, удовлетворяющие условию, оформить в виде списка.
Для формирования списка использовать генератор.
Пример исходного списка: [300, 2, 12, 44, 1, 1, 4, 10, 7, 1, 78, 123, 55].
Результат: [12, 44, 4, 10, 78, 123].

Реализуйте вариант без lc и с lc
"""

primary_list = [300, 2, 12, 44, 1, 1, 4, 10, 7, 1, 78, 123, 55]

# традиционный итератор с ф-цией append
res_list_1 = []
for el in range(1, len(primary_list)):
    if primary_list[el] > primary_list[el - 1]:
        res_list_1.append(primary_list[el])

print(res_list_1)

# вариант с lc
res_list_1 = [primary_list[el] for el in range(1, len(primary_list)) if primary_list[el] > primary_list[el - 1]]
print(res_list_1)


lst = [1, 2, 3, 4]
res_2 = []
for el in lst:
    if el > 0:
        res_2.append(el*2)

res_2 = [el*2 for el in lst if el > 0]
print(res_2)