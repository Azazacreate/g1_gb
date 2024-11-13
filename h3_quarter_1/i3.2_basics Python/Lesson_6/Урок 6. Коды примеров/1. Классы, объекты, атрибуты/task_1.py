class Car:
    wheels = 4
    rule = 1

    def __init__(self, a, b):
        self.color = a
        self.engine = b

    def start(self):
        return 'поехали'

obj_1 = Car('black', 'gas')
print(obj_1.rule)
obj_1.rule = 2
print(obj_1.rule)
print(obj_1.color)
obj_1.color = 'red'
print(obj_1.start())
print(Car.__dict__)


class Car:
    def __str__(self):
        return "Привет"

    def __add__(self, other):

    def __mul__(self, other):


o_1 = Car()
print(o_1.)
