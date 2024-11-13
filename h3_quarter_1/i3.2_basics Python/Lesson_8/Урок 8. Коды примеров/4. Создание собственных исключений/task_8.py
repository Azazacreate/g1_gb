# 1. Создать класс-исключение от класса Exception
# 2. Сгенерировать исключение в нужной точке программы
# 3. Отловить и обработать

class OwnError(Exception):
    def __init__(self, txt):
        self.txt = txt


inp_data = input("Введите положительное число: ")


try:
    inp_data = int(inp_data)
    if inp_data < 0:
        raise OwnError("Вы ввели отрицательное число!")
except OwnError as e:
    print(e)
except ValueError:
    print("Вы ввели строку")



"""
Введите положительное число: 5
Все хорошо. Ваше число: 5

Введите положительное число: text
Вы ввели не число

Введите положительное число: -65
Вы ввели отрицательное число!
"""
