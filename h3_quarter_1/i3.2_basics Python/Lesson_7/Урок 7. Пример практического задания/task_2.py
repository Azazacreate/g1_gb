def upend(num, upend_num = 0, null_num = ''):
    if num == 0:
        print(f'Перевернутое число: {null_num}{upend_num}')
        return
    else:
        if num % 10 == 0:
            null_num = '0'
        upend_num = upend_num * 10 + num % 10
        return upend(num // 10, upend_num, null_num)


upend(num = int(input("Введите целое число: ")))