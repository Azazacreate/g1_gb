class NewEx(Exception):
    pass



try:
    a = int(input("Ваш доход: "))
    if a < 0:
        raise NewEx()
except NewEx:
    print("Вы ввели отриц.")





a = 'b'
c = int(a)
