"""Оператор return без значения"""


def s_calc(r_val, h_val):
    s_side = 2 * 3.14 * r_val * h_val
    s_circle = 3.14 * r_val ** 2
    s_full = s_side + 2 * s_circle
    return s_full

try:
    r_val = float(input("Укажите радиус: "))
    h_val = float(input("Укажите высоту: "))
except ValueError:
    print("! ValueError")
else:
    print(s_calc(r_val, h_val))







