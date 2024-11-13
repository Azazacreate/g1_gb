"""__add__"""


class MyClass:
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def __add__(self, other):
        return MyClass(self.width + other.width, self.height + other.height)

    def __str__(self):
        return f"Объект с параметрами ({self.width}, {self.height})"


mc_1 = MyClass(10, 20)
mc_2 = MyClass(30, 40)
print(mc_1 + mc_2)  # -> Объект с параметрами (40, 60)
