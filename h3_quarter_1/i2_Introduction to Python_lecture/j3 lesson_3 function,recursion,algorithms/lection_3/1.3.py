# функция, которая принимает количество:не-ограниченное аргументов 
# & объединяет все-строки в-1-строку:целую.
def sum_str(*args):
    res = ""
    for i in args:
        res += i
    return res
print(sum_str("1","2","3"))
print(sum_str("1","2","3", "4", "5", " = good"))
print(sum_str(1, 2, 3))