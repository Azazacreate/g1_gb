def reverse(num):
    if num < 10:
        return str(num)
    return str(num % 10) + reverse(num // 10)


num = int(input('Введите число: '))
print(f'Перевернутое число: {reverse(num)}')