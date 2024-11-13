# класс Auto
class Auto:

    # конструктор класса Auto
    def __init__(self, year):
        # Инициализация свойств.
        self.__year = year

    # создаем свойство года
    @property
    def year(self):
        return self.__year

    # сеттер для создания свойств
    @year.setter  # AttributeError: 'function' object has no attribute 'setter'
    def year(self, year):
        if year < 2000:
            self.__year = 2000
        elif year > 2020:
            self.__year = 2020
            print("Вы указали неверный год")
        else:
            self.__year = year



a = Auto(2021)
print(a.year)
a.year = 1999
print(a.year)
