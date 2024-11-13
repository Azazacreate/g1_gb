from random import randint
n = 10
list__days = [randint(-50, 50) for i in range(n)]
summ1 = 0
summ1_max = 0
i = 0


while i != n:
    if list__days[i] > 0:
        summ1 += 1
        i += 1
        if summ1 > summ1_max:
            summ1_max = summ1
    else:
        summ1 = 0
        i += 1
print(list__days)
print(i, summ1_max)