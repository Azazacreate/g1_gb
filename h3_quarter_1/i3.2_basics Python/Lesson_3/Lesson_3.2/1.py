

# 2
# def s_calc():
#     try:
#         r_val = float(input("Укажите радиус: "))
#         h_val = float(input("Укажите высоту: "))
#     except ValueError:
#         return
#     s_side = 2 * 3.14 * r_val * h_val
#     s_circle = 3.14 * r_val ** 2
#     s_full = s_side + 2 * s_circle
#     return s_full
# print(s_calc())


# 3
# def func_2(a=1, b=2):
#     return a + b
# print(func_2(4))


# 4
# list_1 = [1, 2, 3]
# print(list(map(lambda a: a + 10, list_1)))


# 5
# print(list(reversed(list_1)))
# print(round(5.006, 2))


#6  неопределенное число позиционных параметров
# def my_func(*args):
#     return args
# print(my_func(10, "text_1", 20, "text_2"))


#7  неопределенное число именованных параметров
# def my_func(**kwargs):
#     return kwargs
# print(my_func(el_1=10, el_2=20, el_3="text"))


#8 def_1    function:very-simple
# def def1(a=int(input("Input: "))):
#     return 1 + 2 + a
# print(def1())


#9
# def ext_func():
#     my_var = 0
#     def int_func():
#         nonlocal my_var
#         my_var += 1
#         return my_var
#     return int_func
#
# func_obj = ext_func()
# print(func_obj)
# print(func_obj())
# print(func_obj())
# print(func_obj())


#10
print(help(memoryview))
print((list(filter(lambda x: x % 2 == 0, [3, 4, 5]))))