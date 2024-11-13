# 1 read()
# a1 = open("text_1.txt", "r")
# a2 = a1.read()
# print(a2)
# a1.close()


#2 readline()
# my_f = open("text_1.txt", "r")
# content = my_f.readline()
# print(content)
# my_f.close()


#3 readlines()
# my_f = open("text_1.txt", "r")
# content = my_f.readlines()
# print(content)
# my_f.close()


# 4 Чтение файла по частям
# my_f = open("text_1.txt", "r")
# for line in my_f:
#     print(line)
# my_f.close()


# 5 построчное извлечение содержимого в цикле for.
# my_f = open("text_1.txt", "r")
# while True:
#     content = my_f.read(1024)
#     print(content)
#     if not content:
#         break


# 6 /**/
# вывести строки с-индексами 1-2
# a1 = open("text_1.txt", "r")
# list_1 = list(a1.read().split("\n"))
# for el in range(1, 3):
#     print(list_1[el])
# a1.close()


# 1[2
# out_f = open("out_file.txt", "w")
# out_f.write("String string string")
# out_f.close()


# 1[2[2 writelines(), принимающего список строк
# out_f = open("out_file.txt", "w")
# str_list = ['stroka_1\n', 'stroka_2\n', 'stroka_3\n']
# out_f.writelines(str_list)
# out_f.close()


#2[ Менеджеры контекста
# with open("text_1.txt", "r+") as a1:
#     print(a1.writelines("sdkfjldsfkjsdl ksdjfskdj_2 dsfj_3\n"))
#     print(a1.mode)

#7[ Print to-file
# with open("text_1.txt", "a") as a2:
#     print("Не-обычная работа функции print", file=a2)


#9[2
# import json
# data = {
#     "income": {
#         "salary": 50000,
#         "bonus": 20000
#     }
# }
# with open("my_file.json", "w") as write_f:
#     json.dump(data, write_f)


#9[2[2
# json_str = json.dumps(data)
# print(json_str)
# print(type(json_str))


#9[3
# with open("my_file.json") as read_f:
#     data = json.load(read_f)
#
# print(data)
# print(type(data))


#10[
import sys
print(sys.argv)
print(sys.executable)
print(sys.platform)
print(sys.stdin)