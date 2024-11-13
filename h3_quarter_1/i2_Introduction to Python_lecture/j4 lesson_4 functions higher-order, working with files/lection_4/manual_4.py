# # 1
# def f(x):
# 	return x ** 2
# print(f(2))     # 4
#
#
# # 2
# def f(x):
#     return x ** 2
# g = f
# print(f(4))     # 16
# print(g(4))     # 16
#
#
# 3
# def calc1(x):
#     return x + 10
# print(calc1(10))    # 20
#
#
# 4
# def calc2(x):
#     return x * 10
# def math(op, x):
#     print(op(x))
# math(calc2, 10)
#
#
# # 5
# def sum(x, y):
#     return x + y
# def mylt(x, y):
#     return x * y
# def calc(op, a, b):
#     print(op(a, b))
# calc(mylt, 4, 5)    # 20
#
#
# # 6
# def sum(x, y):
#     return x + y
# f = sum
# calc(f, 4, 5)       # 9


# 7     function-lambda
# def sum(x, y):
#     return x + y
# # ⇔ (равносильно)
# sum = lambda x, y: x + y
#
# print(sum(2, 3))


# 8
# def calc(op, a, b):
#     print(op(a, b))
# calc(lambda x, y: x + y, 4, 5)      # 9


# 9     task:independent
# list_1 = [1, 2, 3, 5, 8, 15, 23, 38]
# list_2 = []
# for i in list_1:
#     if i % 2 == 0:
#         # list_1.pop(i)
#         list_2.append((i, i ** 2))
# print(list_2)


# 9.2       solution_my_1th
# не-получилось


# 9.3       Как можно-сделать этот-код лучше, используя lambda?
# def select(f, col):
#     return [f(x) for x in col]
# def where(f, col):
#     return [x for x in col if f(x)]
#
#
# data = [1, 2, 3, 5, 8, 15, 23, 38]
# res = select(int, data)
# res = where(lambda x: x % 2 == 0, res)
# print(res)          # [2, 8, 38]
# res = list(select(lambda x: (x, x ** 2), res))
# print(res)          # [(2, 4), (8, 64), (38, 1444)]


# 9.4       я упростил вроде. а я не-знаю, что f(x) есть?
# def where(f, count):
#     return [x for x in count if f(x)]
# data = [1, 2, 3, 5, 8, 15, 23, 38]
# data = where(lambda x: x % 2 == 0, data)
# print(data)          # [2, 8, 38]
# data = list(map(lambda x: (x, x ** 2), data))
# print(data)


# 9.5
# def where(f, col):
#     return [x for x in col if f(x)]
#
#
# data = [1, 2, 3, 5, 8, 15, 23, 38]
# res = map(int, data)
# res = where(lambda x: x % 2 == 0, res)
# print(res)                               # [2, 8, 38]
# res = list(map(lambda x: (x, x ** 2), res))
# print(res)


# 10        function-map
# list_1 = [x for x in range (1,20)]
# print(list_1)
# list_1 = list(map(lambda x: x + 10, list_1))
# print(list_1)


# 11 task_2
"""
C клавиатуры вводится некий набор чисел, в качестве разделителя используется пробел. Этот набор чисел будет считан в качестве строки. Как превратить list-строк в list-чисел?
"""
# data_1 = "1 2 3 4 5 6 7 8 9 10".split()
# print(data_1)
# data_2 = list(map(int, data_1))
# print(data_2)


# 12    function-filter()
# data = [x for x in range(10)]
# res = list(filter(lambda x: x % 2 == 0, data))
# print(res)      # [0, 2, 4, 6, 8]


# 13    filter() позволит избавиться от функции where, которую мы писали ранее
# data = '1 2 3 5 8 15 23 38'.split()
# res = map(int, data)
# res = filter(lambda x: x % 2 == 0, res)
# res = list(map(lambda x: (x, x ** 2), res))
# print(res)


# 14    function-zip()
# users = ['user1', 'user2', 'user3', 'user4', 'user5']
# ids = [4, 5, 9, 14, 7]
# data = list(zip(users, ids))
# print(data)
# [('user1', 4), ('user2', 5), ('user3', 9), ('user4', 14), ('user5', 7)]


# 15
# users = ['user1', 'user2', 'user3', 'user4', 'user5']
# ids = [4, 5, 9, 14, 7]
# salary = [111, 222, 333]
# data = list(zip(users, ids, salary))
# print(data) # [('user1', 4, 111), ('user2', 5, 222), ('user3', 333)]


# 16 function-enumerate()
# users = ['user1', 'user2', 'user3']
# data = list(enumerate(users))
# print(data) # [(0, 'user1'), (1, 'user2'), (2, 'user3))]


# 17 Files
# 17.1  mod-a
# colors = ['red', 'green', 'blue']
# data = open('file.txt', 'a') # здесь указываем режим, в котором будем работать
# data.writelines(colors) # разделителей не будет
# data.close()
#
#
# 18    mod-a
# with open('file.txt', 'w') as data:
#     data.write('line 1\n')
#     data.write('line 2\n')


#19     mod-r
# path = 'file.txt'
# data = open(path, 'r')
# for line in data:
#     print(line)
# data.close()


# 20    mod-w
colors = ['red', 'green', 'blue']
data = open('file.txt', 'w')
data.writelines(colors) # разделителей не будет
data.close()
