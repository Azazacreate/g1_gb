"""
Генератор - итерируемый объект, который можно использовать один раз,
т. к. при использовании генератора значения не хранятся в памяти,
а формируются в процессе обращения к ним, по мере запроса.
"""
# lst = []
# for el in range(10):
#     if el % 2 == 0:
#         lst.append(el)
#
lst = [el for el in range(10)]
for el in lst:
    print(el)

for el in lst:
    print(el)


gen = (el for el in range(10))
for el in gen:
    print(el)





