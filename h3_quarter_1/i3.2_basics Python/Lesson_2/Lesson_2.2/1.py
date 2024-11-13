# # int
# print(abs(-6))  # -> 6
# print(4 & 6)    # -> 4
#
# # bin() двоичный
# print(int(17.5))        # -> 17
# print(int('10001', 2))  # -> 17
# print(bin(17))          # -> 0b10001
#
# # complex()
# n_1 = complex(5, 6)
# print(n_1)
# n_2 = complex(7, 8)
# print(n_2)
#
# # str
# my_str = "простая строка"
# print(my_str)
# print(type(my_str))

# реверс строк_1. срез
# string = "abrakadbra"
# str_reverse = string[::-1]
# print(str_reverse)
#
# реверс строк_2. итерация:обратная
# for el in reversed("abrakadbra"):
#     print(el)

# реверс строк_3. реверс на-месте.
# string = "abrakadabra"
# string_2 = list(reversed(string))
# string_3 = "".join(string_2)
# print(string)
# print(string_2)
# print(string_3)


# list
# print(reversed(list("обычная строка")))


# dictionary
# dict_1 = {1:500, 2:300, 4:400, "5":500}
# print(dict_1.popitem())
# print(dict_1)


# dict_2 = {1: 100, 2: "200", 3: 303, 4: "404"}
# dict_3 = {1: 200, 5: "505", 6: 0.06}
# dict_2.update(dict_3)
# print(dict_2)


# popitem
# my_dict = {"key_1": 500, 2: 400, "key_3": True, 4: None}
# print(my_dict.popitem())
# print(my_dict.popitem())
# print(my_dict.popitem())
# print(my_dict.popitem())
# print(my_dict)


# bytes and bytearray
# print(bytes('text', encoding = 'utf-8'))

# my_var = bytearray(b"some text")
# print(my_var)
# print(my_var[0])
# #my_var[0] = b'h' -> TypeError: an integer is required
# my_var[0] = 105     # i
# print(my_var)

# my_var = bytearray(b"some text")
# for i in range(len(my_var)):
# 	my_var[i] += i
# print(my_var)


# Поиск самых часто встречающихся элементов списка
# my_list = [10, 20, 20, 20, 30, 50, 70, 30]
# print(set(my_list), my_list.count(20))
#
# my_list = [10, 20, 20, 20, 30, 50, 70, 30]
# print(max(set(my_list), key=my_list.count))


# Сортировка словаря по значениям
# my_dict = {'python': 1991, 'java': 1995, 'c++': 1983}
# print(sorted(my_dict))
#
# my_dict = {'python': 1991, 'java': 1995, 'c++': 1983}
# print(sorted(my_dict, key=my_dict.get))

# The-end.