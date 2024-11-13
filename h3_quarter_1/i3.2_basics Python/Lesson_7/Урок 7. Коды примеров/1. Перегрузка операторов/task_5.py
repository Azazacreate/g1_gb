"""__setattr__"""


class MyClass:
    def __setattr__(self, attr, value):
        print(self.__dict__)
        if attr == "width":
            self.__dict__[attr] = value
        else:
            print(f"Атрибут {attr} недопустим")
        print(self.__dict__)


mc = MyClass()
mc.width = 40
print(mc.__dict__)
