list_1 = [3.64, 5.2, 9.42, 9.35, 8.5, 8]
k = 9.99


def closest(list_1, k):
    return list_1[min(range(len(list_1)),
    key = lambda i: abs(list_1[i] - k))]
print(closest(list_1, k))