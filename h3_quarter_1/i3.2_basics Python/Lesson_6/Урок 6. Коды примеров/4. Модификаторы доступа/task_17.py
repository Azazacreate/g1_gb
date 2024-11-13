import random

s = 1
r_n = float(random.random() * 100)
while s < 10:
    pop_ot = input(f"Отгадайте число у вас: {11 - s} попыт. :")
    if pop_ot == r_n:
        print("Ура вы угадали")
        break
    if pop_ot < r_n:
        print(f"Загаданное число больше: {pop_ot}")
    if s == 10:
        print(f"Вы не угадали за 10 попыток, загадонное число было {r_n}")
    if pop_ot > r_n:
        print(f"Загаданное число меньше: {pop_ot}")
    s += 1
