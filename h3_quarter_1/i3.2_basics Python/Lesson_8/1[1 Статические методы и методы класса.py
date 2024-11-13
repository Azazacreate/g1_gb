class Auto:
    @staticmethod
    def get_class_info():
        print("Детальная информация о классе")

    def get_2(self):
        print("информация. метод_2")


Auto.get_class_info()
Auto().get_2()