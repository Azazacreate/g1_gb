from abc import ABC, abstractmethod


class MyAbstractClass(ABC):

    @abstractmethod
    def my_method_2(self):
        pass


    def my_method_1(self):
        pass


class MyClass(MyAbstractClass):

    def my_method_2(self):
        print("!")



mc = MyClass()
print(type(mc.my_method_2))

"""
TypeError: Can't instantiate abstract class MyClass with abstract methods my_method_1, my_method_2
"""
