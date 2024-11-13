def multi_operation(b, c):
    a = input("Введите операцию которую необходимо провести: ")
    d = 0
    if a == 0:
        return
    if a == '+':
        d = b + c
    elif a == '-':
        d = b - c
    elif a == '*':
        d = b * c
    elif a == '/' and c > 0:
        d = b / c
    elif c == 0:
        print('На ноль делить нельзя')
    print(f'Результат операции: {d}')
    multi_operation(b, c)


b = int(input('Введите первое число: '))
c = int(input('введите второе число: '))
multi_operation(b, c)
