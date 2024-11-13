my_tuple = (2, 4, 6)
new_obj = (el+10 for el in my_tuple)
print(new_obj)





for el in new_obj:
    print(el)

my_tuple = (2, 4, 6)
new_obj = (el+10 for el in my_tuple)
for el in new_obj:
    print(el)