class MyClass:
    def __init__(self, param_1, param_2):
        self.param_1 = param_1
        self.param_2 = param_2

    @property
    def my_method(self):
        return self.param_2



mc = MyClass(1, 2)
print(mc.my_method)




"""
text_1
text_2
Параметры, переданные в класс: text_1, text_2
"""
