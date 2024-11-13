count__n = 5
n = [5, 1, 6, 5, 9]
print(min(n), max(n))


data = [5, 1, 6, 5, 9]
elem_max = 1
elem_min = 1


for elem in data:
    if elem > elem_max:
        elem_max = elem
    elif elem < elem_min:
        elem_min = elem
print(elem_min, elem_max)


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