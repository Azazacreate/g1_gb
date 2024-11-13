# input_string = "a a a b c a a d c d d"
# words = input_string.split()
# counts = {}
# result = []
# for word in words:
#     if word in counts:
#         counts[word] += 1
#         result.append(f"{word}_{counts[word]}")
#     else:
#         counts[word] = 0
#         result.append(word)
# print(" ".join(result))


# 25.3 solve more-shorter with-.get()
str_1 = "a a a b c a a d c d d"
words = str_1.split()
counts = {}
for word in words:
    if word not in counts:
        print(word, end=" ")
    else:
        print(f"{word}_{counts[word]}", end=" ")
    counts[word] = counts.get(word, 0) + 1
print(counts)
