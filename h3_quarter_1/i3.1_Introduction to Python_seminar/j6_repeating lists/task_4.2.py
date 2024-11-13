# Рекурсия.
from sys import setrecursionlimit

k = 10000
setrecursionlimit(10**5)
# иначе -> будет-переполнение стека.


# функция, которая находит пары
def pairs(array):
    if len(array) == 0:
        return
    pairless = array.pop(0)
    for i in array:
        if i[0] == pairless[1] and i[1] == pairless[0]:
            print(f"{pairless[0]} {i[0]}")
    return pairs(array)

def denominators(n, s=1, all_numbers_denominators=None):
    if all_numbers_denominators is None:
        all_numbers_denominators = []
    if s > n:
        return all_numbers_denominators
    denominator_sum = 0
    for i in range(1, s // 2 + 1):
        if s % i == 0:
            denominator_sum += i
    all_numbers_denominators.append((s, denominator_sum, ))
    return denominators(k, s+1, all_numbers_denominators)
pairs(denominators(k))