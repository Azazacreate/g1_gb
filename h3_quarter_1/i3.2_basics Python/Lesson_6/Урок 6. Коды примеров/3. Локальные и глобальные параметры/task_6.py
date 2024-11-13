class Auto:

   def __init__(self, my_var):
       self.__my_var = my_var

   def on_start(self):
       info_2 = "Автомобиль заведен"
       return info_2


a = Auto(1)
print(a._Auto.__my_var)  # -> Автомобиль заведен
# сеттер
# дескрипторы - атрибуты со связанным поведением

#a.info_1 = 1

+