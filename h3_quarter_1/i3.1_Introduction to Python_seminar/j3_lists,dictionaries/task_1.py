# task_1
# a = [1, 1, 2, 0, -1, 3, 4, 4]
# print(len(set(a)))


# task_1.3
# list_1 = []
# while True:
# 	try:
# 		str_1 = int(input())
# 	except ValueError:
# 		print("Вы ввели строку.")
# 		break
# 	else:
# 		list_1.append(str_1)
# print(list_1)


# task1.4
# a = [1, 1, 2, 0, -1, 3, 4, 4]
# a_2 = []
# for el in a:
# 	if el not in a_2:
# 		a_2.append(el)
# print(len(a_2))


# task_2.1
# list_1 = [1, 2, 3, 4, 5]
# k = 3
# list_2 = [] 	# [4, 5, 1, 2, 3]
#
#
# for el in list_1:
# 	list_2.append(el + k)
# print(list_2)


# task_2.2	through-slice
# list_1 = [1, 2, 3, 4, 5]
# k = 3					# [4, 5, 1, 2, 3]
# list_2 = list_1[k:] + list_1[:k]
# print(list_2)


# task_2.3		through-cycle
list_1 = [1, 2, 3, 4, 5]
k = 3					# [4, 5, 1, 2, 3]
list_2 = []


for _ in range(k-1):
	last = list_1.pop()
	list_2.insert(0, last)
print(list_2 + list_1)