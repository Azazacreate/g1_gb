# Практическое задание.


# exercise-1
# a, b, c = 1, "string-2", 0.28,
# print(a, b, c)
# d, e, f = int(input()), input(), float(input())
# print(d, e, f)


# exercise-2
# time = int(input())
# h = time // 3600
# m = time % 3600 // 60
# s = time % 3600 % 60
# print(h, m, s)


#exercise-3
# n = 3
# summ_n = n + int(f"{n}{n}") + int(f"{n}{n}{n}")
# print(summ_n)


# exercise-4.1
# number = 50987
# i = 0
# count__digits = int(len(str(number)))
# list__number = []
#
#
# while i < count__digits:
#     i += 1
#     a = number % 10
#     list__number.append(a)
#     number //= 10
# print(max(list__number))
# print(list__number)


# exercise-4.2
# n = int(input('Write a number: '))
# max = n % 10
# while True:
#     n = n // 10
#     if n % 10 > max:
#         max = n % 10
#     elif n > 9:
#         continue
#     else:
#         print(f'Максимальное число: {max}')
#         break


# exercise-4.3
# number = 50987
# count__digits = int(len(str(number)))
# i = 0
# number_max = 0
#
#
# while i < count__digits:
#     i += 1
#     if number % 10 > number_max:
#         number_max = number % 10
#     number //= 10
# print(number_max)


# exercise-5
# revenue = 250000
# expences = 105000
#
#
# if revenue > expences:
#     print("выручка > издержки")
#     print("revenue/expences = ", revenue/expences)
#     count_employees = int(input())
#     print(revenue/count_employees)
# elif revenue < expences:
#     print("выручка < издержки")
# else:
#     print("выручка = издержки")


# exercise-6
# a = 2
# acceleration = 1.1
# number__day = 1
# b = 3
#
#
# while a < b:
#     a *= acceleration
#     number__day += 1
# print(number__day)


# The-end.