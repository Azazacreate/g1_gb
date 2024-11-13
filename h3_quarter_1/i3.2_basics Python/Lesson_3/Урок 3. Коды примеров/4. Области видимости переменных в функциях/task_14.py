"""Не локальная область видимости"""


# ПРОБЛЕМА
def ext_func():
    my_var = 0

    def int_func():
        nonlocal my_var
        my_var += 1
        return my_var
    return int_func


func_obj = ext_func()

print(func_obj())
