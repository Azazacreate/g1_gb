# традиционный итератор с ф-цией append
lst = []
for el in range(10):
    if el % 2 == 0:
        lst.append(el)
print(lst)

# списковое включение (list comprehension - LC)
lst = [el for el in range(10) if el % 2 == 0]
print(lst)

set_obj = set()
for el in range(10):
    if el % 2 == 0:
        set_obj.add(el)
print(set_obj)

set_obj = {el for el in range(10) if el % 2 == 0}
print(set_obj)

dct = {}
for el in range(10):
    dct[el] = el**2
print(dct)


dct = {el: el**2 for el in range(10)}
print(dct)


obj = (el for el in range(10))
print(obj)





lst = [el for el in range(3000)]
for el in lst:
    print(el)


obj = (el for el in range(3000))
for el in obj:
    print(el)

obj = (el for el in range(3000))
for el in obj:
    print(el)









