"""__del__"""


class MyClass:
    def __init__(self, param):
        self.param = param

    def __del__(self):
        print(f"Удаляем объект {self.param} класса MyClass")


mc = MyClass("text")
del mc  # -> Удаляем объект text класса MyClass
