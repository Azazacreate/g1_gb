my_list = [10, 25, 30, 45, 50]
res = []
for el in my_list:
    if el % 2 == 0:
        res.append(el)




# с условием

print(my_list)  # -> [10, 25, 30, 45, 50]
new_list = [el for el in my_list if el % 2 == 0]
print(new_list)  # -> [10, 30, 50]

