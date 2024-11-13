from sys import getrefcount

print(getrefcount([1, 2, 3]))
a = [1, 2, 3]
b = [1, 2, 3]
print(a == b)
print(a is b)

a = [1, 2, 3]
b = a
print(a == b)
print(a is b)
a.append(1)
print(a)
print(b)

print(getrefcount(1))
a = 1
b = 1
print(a == b)
print(a is b)
