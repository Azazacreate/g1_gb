class Auto:

    def __init__(self):
        # публичный
        self.auto_name = "Mazda"
        # защищенный
        self._auto_year = 2019
        # приватный
        self.__auto_model = "CX9"

    def func(self):
        print(self._auto_year)
        self.__auto_model = 2020



a = Auto()
print(a._Auto__auto_model)
a._Auto__auto_model = "!"
print(a._Auto__auto_model)


