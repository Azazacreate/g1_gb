"""
2)	Создать текстовый файл (не программно), сохранить в нем несколько строк, выполнить подсчет количества строк, количества слов в каждой строке.
"""

# Вариант_1. Работает.
# count_lines = 0
# count_words = 1
# with open("m2.txt", "r") as a1:
#     a2 = a1.readlines()
#     for line in a2:
#         print(line.replace("\n", ""))
#         for b in line:
#             if b == " ":
#                 count_words += 1
#         count_lines += 1
#         print(f"Количество слов в строке {count_lines} = {count_words}")
#         count_words = 1
#     print(f"В файле {count_lines} строк(и)")


# вариант_2. упростил
count_lines = 0
count_words = 1
with open("m2.txt", "r") as a1:
    for line in a1:
        count_lines += 1
        for el in line:
            if el == " ":
                count_words += 1
        print("count_words: ", count_words)
        count_words = 1
print("count_lines", count_lines)
