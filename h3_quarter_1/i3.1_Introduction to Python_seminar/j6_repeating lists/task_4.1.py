k = 10000
def get_sum(n):
    sum_current = 1
    # пройти делители:потенциальные числа-n
    # т.е Вы должны-обойти все-числа до-n .
    for el in range(2, n):
        if n % el == 0:
            sum_current += el
    return sum_current


def fill_array(k):
    res = list()
    for n in range(1, k+1):
        if n not in res:
            m = get_sum(n)
            if n == get_sum(m) and m != n:
                res.append(m)
                res.append(n)
    return res


print(fill_array(10000))