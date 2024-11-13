n = 5
f = 1


while n >= 1:
    f *= n
    n -= 1
print(f)

n = 5
f = 1

def function1(n, f = 1):
    if n == 1:
        return f
    return function1(n - 1, f * n)      # шаг__рекурсии
print(function1(5))

if __name__ == "__main__":
    print(function1(5))

