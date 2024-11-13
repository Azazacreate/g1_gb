class Shape:
    a = 1
    def __init__(self, param_1, param_2):
        self.param_1 = param_1
        self.param_2 = param_2

    def get_params(self):
        return f"Параметры Shape: {self.param_1}, {self.param_2}"


class Material:
    a = 2
    def __init__(self, param_1, param_2):
        self.param_1 = param_1
        self.param_2 = param_2

    def get_params(self):
        return f"Параметры Material: {self.param_1}, {self.param_2}"


class Triangle(Material, Shape):
    def __init__(self, param_1, param_2):
        super().__init__(param_1, param_2)
        pass


t = Triangle(10, 20)
print(t.get_params())  # -> Параметры Shape: 10, 20
print(t.a)
