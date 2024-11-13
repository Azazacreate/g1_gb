# 0, 1, 1, 2, 3, 5, 8, 13, 21
a = 5
fibo_p, fibo_n = 0, 1
position = 2


while fibo_n < a:
    fibo_p, fibo_n = fibo_n, fibo_n + fibo_p
    position += 1
if fibo_n == a:
    print(position)
    print(fibo_p, fibo_n)
else:
    print(-1)


def function1(a = 5, fibo_p = 0, fibo_n = 1, position = 2):
    if fibo_n == a:
        return position
    elif fibo_n < a:
        return function1(a, fibo_n, fibo_n + fibo_p, position + 1)
    else:
        print("minus One.")
print(function1())          #вызвать функцию