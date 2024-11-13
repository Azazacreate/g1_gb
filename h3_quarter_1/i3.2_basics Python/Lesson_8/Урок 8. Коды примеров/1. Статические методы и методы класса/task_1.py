class Auto:
    atrr = 1
    @staticmethod
    def get_class_info():
        print("Детальная информация о классе")


a = Auto()
a.get_class_info()
#a.z = 10
#print(a.__dict__)
print(Auto.get_class_info())
