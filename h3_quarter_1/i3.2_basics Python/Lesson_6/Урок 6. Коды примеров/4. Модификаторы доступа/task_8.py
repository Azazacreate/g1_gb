class MyClass:
    __attr = "значение"
    def __method(self):
        print("Это защищенный метод!")


mc = MyClass()
mc.__method()
print(mc.__attr)

"""
Это защищенный метод!
значение
"""
