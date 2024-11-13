# import threading
# class TrafficLight:
#     __color = "red"
#     def running(self):
#         print(TrafficLight.__color)
#         threading.Event().wait(7)
#
#         TrafficLight.__color = "yellow"
#         print(TrafficLight.__color)
#         threading.Event().wait(3)
#
#         TrafficLight.__color = "green"
#         print(TrafficLight.__color)
#         threading.Event().wait(2)
#         TrafficLight.__color = "red"
#
#
# TrafficLight().running()


#practice_2
# class Road:
#     def __init__(self, length, width):
#         self._length = length
#         self._width = width
#     def method_1(self):
#         print(self._length * self._width * 25 * 5)
#
# Road(20, 5000).method_1()


#practice_3
# class Worker:
#     dict_1 = {
#         "wage": "22111",
#         "bonus": "333"
#               }
#     def __init__(self, name, surname, position, income=dict_1):
#         self.name = name
#         self.surname = surname
#         self.position = position
#         self.income = income
#
#
# class Position(Worker):
#     def get_full_name(self):
#         print(self.name, self.surname)
#     def get_total_income(self):
#         a, b = self.income.values()
#         print(int(a)+int(b))
#
#
# Position("Alfred", "Netto", "junior").get_full_name()
# Position("Alfred", "Netto", "junior").get_total_income()
# # OR
# ex_1 = Position
# ex_1("Alfred", "Netto", "junior").get_total_income()
# ex_1("Alfred", "Netto", "junior").get_full_name()


#practice_4
# class Car:
#     def __init__(self, speed, color, name, is_police):
#         self.speed = speed
#     def go(self):
#         print("машина поехала")
#     def stop(self):
#         print("машина остановилась")
#     def turn(self, side="right"):
#         if side == "rigth":
#             print("turn-rigth")
#         else:
#             print("turn-left")
#     def show_speed(self):
#         print(self.speed)
# a = Car
# a(1, 2, 3, 4).go()
# a(1, 2, 3, 4).turn()
# a(1, 2, 3, 4).stop()
# a(1, 2, 3, 4).show_speed()
#
#
# class TownCar(Car):
#     def show_speed(self):
#         print(self.speed)
#         if self.speed > 60:
#             print("Вы превысили скорость!")
#
#
# TownCar(61, "red", 3, False).show_speed()
# SportCar ..
# WorkCar
# PoliceCar
...


#practice_5
class Stationery:
    title = "title_1"
    def draw(self):
        print("Stationery")


class Pen(Stationery):
    def draw(self):
        print("Pen")
class Pencil(Stationery):
    def draw(self):
        print("Pencil")
class Handle(Stationery):
    def draw(self):
        print("Handle")


Stationery().draw()
Pen().draw()
Pencil().draw()
Handle().draw()