def fib_1(n):
    if n in [1, 2]:                 #1 basis__recursion
        return 1
    return fib_1(n-1) + fib_1(n-2)  #2 cause recursion


list_1 = []
for i in range(1, 10+1):
    list_1.append(fib_1(i))
print(list_1)