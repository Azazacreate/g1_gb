def sort_quick(array_1):
    if len(array_1) <= 1:
        return array_1
    else:
        pivot_1 = array_1[0]
    array_less = [i for i in array_1[1:] if i <= pivot_1]
    array_greater = [i for i in array_1[1:] if i > pivot_1]
    return sort_quick(array_less) + [pivot_1] + sort_quick(array_greater)
    # возврат 2_списка:не-отсортированных.
    # и значение между этими-списками.

print(sort_quick([14, 5, 9, 6, 245.2, 3, 58, 7, 5, 2]))
print(sort_quick([10,5,3,2]))