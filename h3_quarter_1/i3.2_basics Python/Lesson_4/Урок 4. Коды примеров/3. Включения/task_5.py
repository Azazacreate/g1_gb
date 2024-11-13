

# традиционный итератор с ф-цией append
my_list = [2, 4, 6]
print(f"Исходный список: {my_list}")  # -> Исходный список: [2, 4, 6]
new_list = []
for el in my_list:
    new_list.append(el + 10)
print(f"Новый список: {new_list}")  # -> Новый список: [12, 14, 16]

# списковое включение
my_list = [2, 4, 6]

res = [el + 10 for el in my_list]

# традиционный итератор с функцией append
lst = []
for el in range(10):
    if el % 2 == 0:
        lst.append(el)

person_lst = [el for el in range(10) if el % 2 == 0]
# list comprehension (LC)


dct = {}
for el in range(10):
    dct[el] = el**2

dct = {el: el**2 for el in range(10)}  # "DC"
