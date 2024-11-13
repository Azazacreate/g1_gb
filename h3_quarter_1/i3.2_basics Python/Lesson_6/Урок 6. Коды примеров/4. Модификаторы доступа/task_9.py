class MyClass:
    __attr = "значение"
    def __method(self):
        print("Это защищенный метод!")


mc = MyClass()
mc.__method()
print(mc._MyClass__attr)  # -> AttributeError: 'MyClass' object has no attribute '__method'
