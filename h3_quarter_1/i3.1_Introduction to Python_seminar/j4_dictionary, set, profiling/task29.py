# list_1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 20, 11, 10]
# max_1 = list_1[0]
# for i in list_1:
# 	if i > max_1:
# 		max_1 = i
# 	if i % 10 == 0:
# 		i = False
# print(max_1)


# 1_Vania
# n = int(input("Input your numbers: "))
# max_number = n			# 1
# while n != 0:
# 	n = int(input())
# 	if max_number < n:		# 2
# 		max_number = n
# print(max_number)


# 2_Petya
n = int(input("Input your numbers: "))
max_number = n				# 1
while n > 0:				# 2
	n = int(input())
	if max_number < n:
		max_number = n		# 3
print(max_number)			# 4

