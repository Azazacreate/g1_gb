# list_1 = [x for x in range(1, 20)]
# print(list_1)
#
#
# list_1 = list(map(lambda x: x + 10, list_1))
# print(list_1)



# task_2
# data = "15 156 96 3 5 8 52 5"
# data = data.split()             # str -> list
# print(data)
#
# data = list(map(int, data))
# print(data)
#
#
# # task_2.2
# data = "15 156 96 3 5 8 52 5"
# data = list(map(int, data.split()))
# print(data)


# 3.1      filter()
# data = [15, 65, 9, 36, 175]
# res = list(filter(lambda a: a % 10 == 5, data))
# print(res)


# 4.1      zip()
# users = ['user1', 'user2', 'user3', 'user4', 'user5']
# ids = [4, 5, 9, 14, 7]
# data = list(zip(users, ids))
# print(data)
# [('user1', 4), ('user2', 5), ('user3', 9), ('user4', 14), ('user5', 7)]


# 4.2
# users = ['user1', 'user2', 'user3', 'user4', 'user5']
# ids = [4, 5, 9, 14, 7]
# salary = [111, 222, 333]
# data = list(zip(users, ids, salary))
# print(data) # [('user1', 4, 111), ('user2', 5, 222), ('user3', 333)]


# 5     enumerate()
# print(list(enumerate(["Sopha", 2, "three", 4.0, "Five", "Final."])))
#
#
# # 5.2
# users = ['user1', 'user2', 'user3']
# data = list(enumerate(users))
# print(data) # [(0, 'user1'), (1, 'user2'), (2, 'user3))]


# 6.1 Files.
# mod-a
colors = ['red', 'green', 'blue', " mod-a"]
# data = open('file.txt', 'a') # здесь указываем режим, в котором будем работать
# data.writelines(colors) # разделителей не будет
# data.close()


# 6.2 way_2
# with open('file.txt', 'w') as data:
# 	data.write('line 1\n')
# 	data.write('line 2\n')

# 6.3 mod-r
# path = 'file.txt'
# data = open(path, 'r')
# for line in data:
#     print(line)
# data.close()


# 7 way-4
with open("file.txt", "r+") as data:
	data.writelines(colors)
	data.write("\n")
	data.writelines(colors)
	for line in data:
		print(line)