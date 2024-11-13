numbers = "-20 30 -40 50 10 -10".split()
lenght = 0
lenght_max = 0


for elem in numbers:
    num = int(elem)
    if num > 0:
        lenght += 1
    else:
        lenght = 0
    if lenght > lenght_max:
        lenght_max = lenght


print(lenght_max)