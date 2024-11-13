def func_1(number_1=5):
    for num in range(2, number_1):
        if number_1 % num == 0:
            return "no"
    return "yes"
print(func_1(7))


def func_1(number_1=5, num=2):
    if num < number_1:
        if number_1 % num == 0:
            return "no"
        return func_1(number_1, num+1)
    return "yes"
print(func_1(7))
