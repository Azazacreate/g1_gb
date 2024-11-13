class Auto:
    # атрибуты класса
    auto_count = 0

    # методы класса
    def __init__(self):
        self.auto_count += 1

    def __add__(self, other):
        res = self.auto_count + other.auto_count
        return res

    def __mul__(self, other):
        return self.auto_count * other.auto_count

    def __str__(self):
        return "приве"


a_1 = Auto()
a_2 = Auto()
print(a_1)



"""
1
2
3
"""
