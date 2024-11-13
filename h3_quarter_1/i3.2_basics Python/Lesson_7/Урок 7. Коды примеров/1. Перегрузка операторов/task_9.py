"""__eq__"""


class MyClass:
    def __init__(self):
        self.x = 40

    def __eq__(self, y):
        print("!")


mc_1 = MyClass()
mc_2 = MyClass()
print(mc_1 == mc_2)

"""
Равно
Не равно
"""
