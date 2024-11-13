# класс Transport
class Transport:
    @property
    def transport_method():
        print("Родительский метод класса Transport")


# класс Auto, наследующий Transport
class Auto(Transport):
    pass

# перегрузка
# переопределение
# класс Bus, наследующий Transport
class Bus(Transport):
    def transport_method(self):
        print("Дочерний метод класса Bus")


a = Auto()
a.transport_method()
b = Bus()
b.transport_method()

"""
Родительский метод класса Transport
Родительский метод класса Transport
"""
