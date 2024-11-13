"""Локальная область видимости"""


def full_s_calc():
    global r_val
    r_val = float(input("Укажите радиус: "))
    h_val = float(input("Укажите высоту: "))
    s_side = 2 * 3.14 * r_val * h_val
    s_circle = 3.14 * r_val ** 2
    s_full = s_side + 2 * s_circle
    print(s_full)
    return s_full


s_val = full_s_calc()
print(r_val)


"""
Укажите радиус: 4
Укажите высоту: 3
175.84
Traceback (most recent call last):
  File "my_file.py", line 11, in <module>
    print(s_side)
NameError: name 's_side' is not defined
"""
