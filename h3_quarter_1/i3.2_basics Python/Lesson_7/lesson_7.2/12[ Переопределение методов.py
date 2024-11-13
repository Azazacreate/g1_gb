class ParentClass:
    def __init__(self):
        print("Конструктор класса-родителя")

    def my_method(self):
        print("Метод my_method() класса ParentClass")


class ChildClass(ParentClass):
    def __init__(self):
        print("Конструктор дочернего класса")
        ParentClass.__init__(self)

    def my_method(self):
        print("Метод my_method() класса ChildClass")
        ParentClass.my_method(self)


c = ChildClass()
c.my_method()


#2
class ParentClass:
   def __init__(self):
       print("Конструктор класса-родителя")
   def my_method(self):
       print("Метод my_method() класса ParentClass")


class ChildClass(ParentClass):
   def __init__(self):
       print("Конструктор дочернего класса")
       super().__init__()
   def my_method(self):
       print("Метод my_method() класса ChildClass")
       super().my_method()


c = ChildClass()
c.my_method()
