

my_dict = {el: el*2 for el in range(10, 20)}
print(my_dict)  # -> {10: 20, 11: 22, 12: 24, 13: 26, 14: 28, 15: 30, 16: 32, 17: 34, 18: 36, 19: 38}

#my_set = {el**3 for el in range(5, 10)}
#print(my_set)  # -> {512, 343, 216, 729, 125}


my_set = {el**3 for el in range(0, 10)}
print(my_set)

my_dict = {el: el**3 for el in range(0, 10)}
print(my_dict)
