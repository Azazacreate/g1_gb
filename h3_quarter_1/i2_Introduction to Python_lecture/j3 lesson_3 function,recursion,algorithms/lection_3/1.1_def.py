# way_1
def sumNumbers(n, summ1 = 0):
    for i in range(1, n+1):
        summ1 += i
    print(summ1)
sumNumbers(5)                   #15


# way_2_return
def sumNumbers(n, summ1=0):
    for i in range(1, n+1):
        summ1 += i
    return summ1
print(sumNumbers(6))            # 21