class User:
    pass

class NewClass:
    pass


class MyClass(User, NewClass):
    """Привет"""
    @classmethod
    def my_method(cls):  # Метод класса
        print(cls.__dict__)



MyClass.my_method()  # Вызов метода через название класса
mc = MyClass()
print(mc.my_method())