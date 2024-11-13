"""
Требуется вывести все целые степени двойки 
(т.е. числа вида 2k), не превосходящие числа N.


n=16

#Вывод
1
2
4
8
16
"""

n = 16
stop = 0
p = 2
for i in range(n):
    if stop != 1:
        p = p ** i
        if p <= n:
            print(p)
            p = 2
        else:
            stop = 1
    else:
        i = n