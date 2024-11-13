def func_1(n):
    list_1 = [el for el in range(n)]
    return list_1
print(func_1(5))


def func_2(n):
    for el in range(n):
        yield el
print(func_2(5))
print()
print(list(func_2(5)))

for el in func_2(5):
	print(el, end=" ")
print(end="\n")


print({el for el in range(10)})