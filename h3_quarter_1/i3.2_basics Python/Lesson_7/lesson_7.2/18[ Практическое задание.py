# class Matrix:
#     def __init__(self, *args):
#         self.list_1 = args
#     def __str__(self):
#         return "\n".join(map(str, self.list_1))
#     def __add__(self, other):
#         list_2 = []
#         str_2 = []
#         for x in range(len(self.list_1)):
#             for y in range(len(self.list_1[x])):
#                 str_2.append(self.list_1[x][y] + other.list_1[x][y])
#             list_2.append(str_2)
#             str_2 = []
#         return "\n".join(map(str, list_2))
# m1 = Matrix([0, 1, 2], [3, 4, 5], [6, 7, 8])
# m2 = Matrix([0, 1, 2], [3, 4, 5], [6, 7, 8])
# print(m1)
# print("+")
# print(m2)
# print("=")
# print(m1 + m2)


# task_2.1
# class Cloth:
#     def __init__(self, name):
#         self.name = name
# class Coat(Cloth):
#     def __init__(self, name, size):
#         super().__init__(name)
#         self.size = size
#         print(self.name, self.size)
# class Suit(Cloth):
#     def __init__(self, name, growth):
#         super().__init__(name)
#         self.growth = growth
#         print(self.name, self.growth)
# Coat("Coat_1", 46)


# task_2.2
# class Cloth:
#     def __init__(self, name):
#         self.name = name
#
#     def coat(self, size):
#         self.size = size
#         print(round((size / 6.5 + 0.5), 1))
#
#     def suit(self, growth):
#         self.growth = growth
#         print(round((2 * growth + 0.3), 1))
#
#
# cloth_1 = Cloth("Viletta-1").coat(46)
# cloth_2 = Cloth("Zabetra-2").suit(54)


# task_3
class Cell:
    def __init__(self, counts_1):
        self.counts_1 = counts_1

    def __add__(self, other):
        return self.counts_1 + other.counts_1

    def __sub__(self, other):
        if self.counts_1 - other.counts_1 >= 0:
            return self.counts_1 - other.counts_1
        else:
            return "False! разность количества ячеек двух клеток должна быть больше нуля"

    def make_order(self, counts_2):
        self.counts_2 = counts_2
        while self.counts_1 >= self.counts_2:
            print("*" * self.counts_2)
            self.counts_1 -= self.counts_2
        if self.counts_1 > 0:
            print("*" * self.counts_1)


print(Cell(3)+Cell(4))
print(Cell(3)-Cell(4))
Cell(11).make_order(3)
