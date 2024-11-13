"""__getitem__"""


class Class1:
    def __init__(self, param):
        self.param = param




class Class2:
    def __init__(self, *args):
        self.my_list = []
        for el in args:
            self.my_list.append(Class1(el))
        print(self.my_list)

    def __getitem__(self, index):
        return self.my_list[index]


my_obj = Class2(10, True, "text")

print(my_obj[0])




"""
10
True
text
"""
