"""Аргументы функций: позиционные и именованные"""


# позиционные параметры
def first_func(var_1, var_2, var_3=30):
    return var_1 + var_2 + var_3


print(first_func(10, 20, 40))  # -> 60


# именованные параметры
def second_func(var_3, var_2, var_1):
    print(f"var_2 - {var_2}; var_1 - {var_1}; var_3 - {var_3}")  # -> var_2 - 20; var_1 - 10; var_3 - 30

var_1 = 1
second_func(var_1=1, var_2=20, var_3=30)
