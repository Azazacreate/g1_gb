# 4.1
# n = [3, 4]
# print(n[-1::-1])


# 4.2_Kirill
# def seq(n):
#     n_2 = input("Input your number: ")
#     if n > 1:
#         seq(n - 1)
#     print(n_2, end=" ")
# seq(2)


# 4.3 Давайте сделаем цикл.
# def func_1(data):
#     data_new = ""
#     for s in reversed(data):
#         data_new += s
#     return data_new
# print(func_1("3 4 -"))


# 4.4
def func_2(data, data_new=""):
    if len(data) == 0:
        return data_new
    return func_2(data[:-1], data_new+data[-1])
print(func_2("1 2 3 4"))


# 4.5