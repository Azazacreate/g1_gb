# 7[1
# class MyClass:
#     _attr = "значение"
#     def _method(self):
#         print("Это защищенный метод!")
#
# mc = MyClass()
# mc._method()
# print(mc._attr)


# 7[2
# class MyClass:
#     __attr = "значение"
#     def __method(self):
#         print("Это защищенный метод!")
#
# mc = MyClass()
# mc.__method()
# print(mc.__attr)


# 7[3
# class MyClass:
#     __attr = "значение"
#     def __method(self):
#         print("Это защищенный метод!")
# mc = MyClass()
# mc._MyClass__method()
# print(mc._MyClass__attr)


#10[
# класс Auto
# class Auto:
#     def auto_start(self, param_1, param_2=None):
#         if param_2 is not None:
#             print(param_1 + param_2)
#         else:
#             print(param_1)
#
#
# a = Auto()
# a.auto_start(50)
# a.auto_start(10, 20)


# 11[
class TrafficLight:
    __color = "red"
    def runnung(self):
        if self.__color == "red":
            self.__color = "yellow"
        if self.__color == "yellow":
            self.__color = "black"
        print(self.__color)
TrafficLight().runnung()