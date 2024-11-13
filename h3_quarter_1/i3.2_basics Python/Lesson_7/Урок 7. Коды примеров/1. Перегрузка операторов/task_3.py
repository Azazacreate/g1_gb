"""__str__"""


class MyClass:
    def __init__(self, param_1, param_2):
        self.param_1 = param_1
        self.param_2 = param_2

    def __str__(self):
        return f"Объект с параметрами ({self.param_1}, {self.param_2})"


mc = MyClass("text_1", "text_2")
print(mc)
