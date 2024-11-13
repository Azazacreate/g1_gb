"""Простейшие анонимные функции"""


def named_func(param):
    return param ** 0.5


obj = lambda param: param ** 0.5

print(obj(10))


def func(*args):
    a = list(args)
    print(args)

func(1, 2, 'a')