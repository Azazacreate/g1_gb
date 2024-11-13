def sumNumbers(n, y = "value_default", summ1 = 0):
    print(y)
    for i in range(1, n+1):
        summ1 += i
    return summ1


a = sumNumbers(5, "value_given")
print(a)