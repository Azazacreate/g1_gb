# не-будем-рассматривать случаи, когда число1 = число2


# way_1
def max1(a, b):
    if a > b:
        return a
    else:
        return b


# way_2
def max2(a, b):
    if a > b:
        return a
    return b


# way_3     количество__аргументов:не-ограниченное
def max3(*args, summ1=0):
    for i in args:
        if i > summ1:
            summ1 = i
    return summ1