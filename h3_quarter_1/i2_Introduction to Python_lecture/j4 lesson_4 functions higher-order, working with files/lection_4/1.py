# p_1
# def f(x=5):
#     return x*x
# print(f(7))
# a = f
# print(a(8), f(8))


# 2
# def calc_1(a):
#     return a + a
# def calc_2(a):
#     return a * a
# def math(op, x):
#     print(op(x))
#
#
# math(calc_1, 5)
# math(calc_2, 5)


# 3
# def calc_1(a, b):
#     return a + b
# def calc_2(a, b):
#     return a * b
# def math(op, x, y):
#     print(op(x, y))
#
#
# math(calc_1, 5, 45)        # 50
# math(calc_2, 5, 45)        # 225


# 4 lambda-function
def calc_2(a, b):
    return a * b
def math(op, x, y):
    print(op(x, y))
math(lambda a,b: a + b, 5, 45)