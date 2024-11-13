#1
# from abc import ABC, abstractmethod
#
# class MyAbstractClass(ABC):
#     @abstractmethod
#     def my_method_1(self):
#         pass
#     @abstractmethod
#     def my_method_2(self):
#         pass
#
# class MyClass(MyAbstractClass):
#     pass
#
# mc = MyClass()


#2
from abc import ABC, abstractmethod

class MyAbstractClass(ABC):
    @abstractmethod
    def my_method_1(self):
        pass
    @abstractmethod
    def my_method_2(self):
        pass

class MyClass(MyAbstractClass):
    def my_method_1(self):
        print("Метод my_method_1()")

    def my_method_2(self):
        print("Метод my_method_2()")

mc = MyClass()
mc.my_method_1()
