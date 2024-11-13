"""
Оператор yield по назначению схож с оператором return,
но возвращает генератор вместо значения
"""


def func():
    lst = [el for el in range(10)]
    return lst

res = func()
for el in res:
    print(el)


def func():
    for el in range(10):
        yield el


res = func()
for el in res:
    print(el)

print()

res = func()
for el in res:
    print(el)





"""
<generator object generator at 0x000001EC0AB5D5C8>
10
20
30
"""
