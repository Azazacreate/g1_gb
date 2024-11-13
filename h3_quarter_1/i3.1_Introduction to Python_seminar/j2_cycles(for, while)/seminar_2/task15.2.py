data = [5, 1, 6, 5, 9]


def func1(data, elem_min = data[0], elem_max = data[0]):
    if len(data) == 0:
        return elem_min, elem_max

    if data[0] > elem_max:
        elem_max = data[0]
    elif data[0] < elem_min:
        elem_min = data[0]

    return func1(data[1:], elem_min, elem_max)


print(func1(data))