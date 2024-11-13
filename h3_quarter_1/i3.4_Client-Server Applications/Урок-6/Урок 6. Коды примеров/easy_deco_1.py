"""Простейший декоратор-функция"""

import time


def decorator(func):
    """Сам декоратор"""
    def wrapper():
        """Обертка"""
        print('Сейчас выполняется функция-обёртка')
        time.sleep(2)
        print(f'Это просто ссылка на экземпляр оборачиваемой функции: {func}')
        time.sleep(2)
        print('Выполняем оборачиваемую (исходную) функцию...')
        time.sleep(2)
        res = func()
        time.sleep(2)
        print('Выходим из обёртки')
        return res
        # обертка может ничего не возвращать
    return wrapper

@decorator
def some_text():
    """Какая-то логика"""
    print('вычисления')

a = decorator(some_text)
a()






#some_text = decorator(some_text)
#some_text()










#some_text = decorator(some_text)
#some_text()

#some_text = decorator(some_text)
#some_text()
