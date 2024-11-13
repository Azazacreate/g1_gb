list_1 = [1, 2, 3, 4, 5, 6]
k = 6


for i in list_1:
    if i == k:
        number1 = i
        print("number1 = k = ", number1)
    elif i > k:
        number2 = i
        print("i - greater than k")
    else:
        number3 = i
        print("k - greater than i")