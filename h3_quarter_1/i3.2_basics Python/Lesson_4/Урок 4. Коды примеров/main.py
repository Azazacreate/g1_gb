def arithmetic_operation():
    operation = input('Введите арифметическую операцию: ')
    if operation in ['+', '-', '/', '*', '0']:
        if operation == '0':
            print('Завершаем работу')
        else:
            try:
                first_number = int(input('Введите первое число: '))
                second_number = int(input('Введите второе число: '))
            except ValueError:
                print('Одно или оба введенных значения не являються числом')
                arithmetic_operation()
            else:
                if operation == '+':
                    summ_of_number = first_number + second_number
                    print(f'Сумма двух чисел = {summ_of_number}')
                    arithmetic_operation()
                elif operation == '-':
                    subtraction = first_number - second_number
                    print(f'Разность двух чисел = {subtraction}')
                    arithmetic_operation()
                elif operation == '*':
                    multiplication = first_number * second_number
                    print(f'Результат умножения двух чисел = {multiplication}')
                    arithmetic_operation()
                elif operation == '/':
                    try:
                        division = first_number / second_number
                    except ZeroDivisionError:
                        print('На ноль делить нельзя, введите другие значения')
                        arithmetic_operation()
                    else:
                        print(f'Результат деление двух чисел = {division}')
                        arithmetic_operation()
    else:
        print('Ввели неверную операцию, попробуйте снова')
        arithmetic_operation()


arithmetic_operation()
