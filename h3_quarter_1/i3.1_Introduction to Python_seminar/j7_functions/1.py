# функция_1:именная
# def func_1(a, b):
# return a ** b


# print(func_1(2, 3))

# переменная, которая ссылается на-объект lambda-function.
# func_2 = lambda a, b: a ** b
# print(func_2(3, 3))


# way_3. вызов без-создания переменной.
# функция_3:анонимная
# print((lambda a, b: a**b)(2, 4))
# объект__функции; вызов функции.


# task_1
# transformation = lambda a: a
# values = [1, 23, 42, "asdfg"]
# transformed_values = orbits_3(map(transformation, values))
# if values == transformed_values:
#     print("ok")
# else:
#     print("fail")


# task_2
# orbits = [(1, 3), (2.5, 10), (7, 2), (6, 6), (4, 3)]
# orbits_2 = []
# for orbits in orbits:
#     if orbits[0] != orbits[1]:
#         orbits_2.append(orbits)
#
#
# def find_farthest_orbit(orbits, orbits_3=[]):
#     if len(orbits) == 0:
#         return max(orbits_3)
#     a, b = orbits[0]
#     orbits_3.append(a * b * 3.14)
#     orbits.pop(0)
#     return find_farthest_orbit(orbits)
#
#
# print(find_farthest_orbit(orbits_2))


# task_2.2
# orbits = [(1, 3), (2.5, 10), (7, 2), (6, 6), (4, 3)]
# def find_farthest_orbit(orbits):
#     return max(orbits, key=lambda orbit: 3.14 * orbit[0] * orbit[1])
# print(find_farthest_orbit(orbits))


# task_2.3      проверка a != b
# orbits = [(1, 3), (2.5, 10), (7, 2), (6, 6), (4, 3)]
# def find_farthest_orbit(orbits):
#     return max([orbits for orbits in orbits if orbits[0] != orbits[1]], key=lambda orbit: 3.14 * orbit[0] * orbit[1])
# print(find_farthest_orbit(orbits))


# task_2.4
# from math import pi
# orbits = [(1, 3), (2.5, 10), (7, 2), (6, 6), (4, 3)]
# def find_farthest_orbit(orbits):
#     return max([orbits for orbits in orbits if orbits[0] != orbits[1]], key=lambda orbit: pi * orbit[0] * orbit[1])
# print(find_farthest_orbit(orbits))


# task_3
# def same_by(characteristic, objects):
# 	print(set(map(characteristic, objects)))
# 	return len(set(map(characteristic, objects))) < 2
#
#
# values = [0, 2, 10, 6, 8, 8, 8]
# if same_by(lambda x: x % 2, values):
# 	print("same")
# else:
# 	print("different")


#task_3.2
# def same_by(characteristic, objects):
# 	if objects == [] or len(set(map(characteristic, objects))) < 2:
# 		return True
# 	else:
# 		return False
#
#
# values = [0, 2, 10, 6]
# if same_by(lambda x: x % 2, values):
# 	print("same")
# else:
# 	print("different")


#task_3.3	оператор:тернарный = return объект if условие == истинно else False.
# def same_by(characteristic, objects):
# 	return True if len(set(map(characteristic, objects))) < 2 else False
#
# values = [0, 2, 10, 6]
# if same_by(lambda x: x % 2, values):
# 	print("same")
# else:
# 	print("different")


#task_3.4
def same_by(characteristic, objects):
	return len(set(map(characteristic, objects))) < 2

values = [0, 2, 10, 6]
if same_by(lambda x: x % 2, values):
	print("same")
else:
	print("different")