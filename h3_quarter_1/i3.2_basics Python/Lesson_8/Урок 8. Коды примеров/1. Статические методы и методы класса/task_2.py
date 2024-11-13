class MyClass:
    @staticmethod
    def on_sum_1(param_1, param_2):  # Статический метод
        return param_1 + param_2

    def on_sum_2(self, param_1, param_2):  # Обычный метод класса
        return param_1 + param_2

    def on_sum_3(self, param_1, param_2):
        return MyClass.on_sum_1(param_1, param_2)  # Вызов статического метода


print(MyClass.on_sum_1(20, 30))  # -> 50

mc = MyClass()
print(mc.on_sum_2(20, 10))  # -> 30

print(mc.on_sum_1(40, 30))  # -> 70

print(mc.on_sum_3(50, 50))  # -> 100
