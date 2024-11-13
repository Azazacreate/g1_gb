# floats = [12.3554, 4.02, 5.777, 2.12, 3.13, 4.44, 11.0001]
# str = ["Vanes", "Alen", "Jana", "William", "Richards", "Joy"]
# int = [22, 33, 10, 6894, 11, 2, 1]
#
# print("1{ ", list(map(lambda x: round(x ** 3, 3), floats)))
# print("2{ ", list(filter(lambda x: len(x) >= 5, str)))
# from functools import reduce
# print("3{ ", reduce(lambda a, b: a * b, int))


#task_2.1
# letters = ['a', 'b', 'c', 'd', 'e']
# numbers = [1, 2, 3, 4, 5, 6, 7, 8]
#
# results: list[tuple[str, int]] = list(map(lambda x, y: (x, y), letters, numbers))
# print(results)


#task_2.2
# letters = ['a', 'b', 'c', 'd', 'e']
# numbers = [1, 2, 3, 4, 5, 6, 7, 8]
# print(list(map(lambda x, y: (x, y), letters, numbers)))


#task_3.1
# def can_be_poly(a1):
#     if a1 == a1[::-1]:
#         print(True)
#     else:
#         print(False)
# can_be_poly("strirts")


#task_3.2
# from collections import Counter
# def can_be_poly(value_1):
#     char_count = Counter(value_1)
#     print(char_count.values())
#     odd_count = len(list(filter(lambda x: x % 2, char_count.values())))
#     return odd_count < 2
# print(can_be_poly("abbccc"))
# print(can_be_poly("abbccca"))


#task_4
message = "Today is a beautiful day! The sun is shining and the birds are singing."


def count_unique_characters(message):
    return len(list(filter(lambda a1: message.lower().count(a1) == 1, message.lower())))

unique_count = count_unique_characters(message)
print("Количество уникальных символов в строке:", unique_count)


# The-end.