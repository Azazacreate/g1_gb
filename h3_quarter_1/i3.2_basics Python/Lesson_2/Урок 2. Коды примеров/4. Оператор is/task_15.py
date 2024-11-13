"""Оператор is"""
from sys import getrefcount

a = [10, 20, 30, 40]
print(getrefcount(a))
b = [10, 20, 30, 40]

print(a == b)  # равенство по значению
print(a is b)  # равенство по ссылке

a = 'a'
print(getrefcount(a))
b = 1
c = 1
print(a == b)
print(a is b)

c = a[:]
c.append(1)
print(c)
print(a)

a = 1
b = 1

a, b = 1, 2

print(a == b)
print(a is b)

if a is b:
    print("Переменные идентичны")
else:
    print("Переменные не идентичны")

'''Переменные идентичны'''

obj_1 = [10, 20, 30, 40]
obj_2 = obj_1
print(obj_1 == obj_2)  # -> True
print(obj_1 is obj_2)  # -> True

obj_2 = obj_1[:]  # переменная obj_2 ссылается на копию obj_1
print(obj_1 == obj_2)  # -> True
print(obj_1 is obj_2)  # -> False
print(obj_1 is not obj_2)  # -> True

obj_1 = None
print(obj_1 is None)  # -> True
