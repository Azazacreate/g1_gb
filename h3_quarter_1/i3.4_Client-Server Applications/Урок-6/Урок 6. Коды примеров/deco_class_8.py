"""Простейший декоратор-класс"""


class Log:
    def __init__(self, num):
        self.num = num

    def __call__(self, func):
        def decorated(*args, **kwargs):
            """Обертка"""
            print(self.num)
            res = func(*args, **kwargs)
            print(f'log: {func.__name__}({args}, {kwargs}) = {res}')
            return res

        return decorated


@Log(10)
def my_func(val_1, val_2):
    """Вычисление"""
    return val_1 ** val_2






#my_func = Log(10)(my_func)

print(my_func(1, 2))

my_func = Log()(my_func)
my_func(4, 5)

print('-- Функции с декораторами --')
# my_func = Log()(my_func)
# my_func(4, 5)

# другой подход применения декоратора к функции func2 = Log()(func2)
# func2 = Log()(func2)
# func2(4, 5)
