"""Возврат набора значений"""


def s_calc(r_val, h_val):
    s_side = 2 * 3.14 * r_val * h_val
    s_circle = 3.14 * r_val ** 2
    s_full = s_side + 2 * s_circle
    return s_side, s_full

try:
    r_val = float(input("Укажите радиус: "))
    h_val = float(input("Укажите высоту: "))
except ValueError:
    print("!")
except ValueError:
    print("!")
else:
    s_side_val, s_full_val = s_calc(r_val, h_val)
    print(f"Площадь боковой пов-ти - {s_side_val}; Полная площадь - {s_full_val}")

"""
Укажите радиус: 4
Укажите высоту: 3
Площадь боковой пов-ти - 75.36; Полная площадь - 175.84
"""
