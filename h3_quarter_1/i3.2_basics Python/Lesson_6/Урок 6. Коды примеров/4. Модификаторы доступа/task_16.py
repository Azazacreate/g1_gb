# класс Auto
class Auto:
    def auto_start(self, param_1, param_2=None):
        if param_2 is not None:
            print(param_1 + param_2)
        else:
            print(param_1)

class Bus:
    def auto_start(self, param_1, param_2=None):
        pass





lst = [Auto(), Bus()]
for el in lst:
    print(el.auto_start(1, 2))

