from sys import getsizeof
from pympler.asizeof import asizeof


d = {1: '1', 2: '2', 3: '3'}
print(getsizeof(d))  # -> 240
print(asizeof(d))  # -> 504

t = (1, 2, 3)
print(getsizeof(t))  # -> 72
print(asizeof(t))  # -> 168


class A:
    __slots__ = ('a', 'b', 'z')
    #a = 1
    def __init__(self, a, b):
        self.a = a
        self.b = b
        self.z = z


obj = A(1, 2)
print(obj.__slots__)
obj.z = 1
print(obj.__slots__)
#print(obj.__dict__)
#print(obj.__slots__)
#print(obj.a)
#obj.a = 3
#obj.z = 5
#print(A.__dict__)
# не упорядочены? - упорядок
