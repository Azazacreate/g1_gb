class User:
    def __init__(self, name):
        self.name = name

    def func(self):
        print("предок")


class Student(User):
    pass


class Teacher(User):
    def func(self):
        print("потомок")


obj = Teacher('вася')
print(obj.func())