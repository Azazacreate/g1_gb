class Person:
    def __init__(self, name_first, name_second):
        self.name_first = name_first
        self.name_second = name_second


class Teacher(Person):
    def __init__(self, name_first, name_second):
        super().__init__(name_first, name_second)


class Student(Person):
    def __init__(self, name_first, name_second):
        super().__init__(name_first, name_second)


class Data(Person):
    def __init__(self, name_first, name_second):
        super().__init__(name_first, name_second)


Teacher("Danila", "Rise")
