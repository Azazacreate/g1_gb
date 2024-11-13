# task_1
class Data:
    def __init__(self):
        self.dmy = input("Input 'day month year' -> ").split()
        print(self.dmy)

    @classmethod
    def method_2(cls):
        cls.dmy = cls.dmy


Data().method_2()