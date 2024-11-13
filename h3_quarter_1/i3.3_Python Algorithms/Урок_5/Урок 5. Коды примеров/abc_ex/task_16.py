from abc import ABC, abstractmethod


class PaymentService(ABC):
    @abstractmethod
    def paypal(self):
        pass


class Site(PaymentService):
    pass


obj = Site()
obj.paypal()


class HexNumber:
    pass


obj_1 = HexNumber()
obj_2 = HexNumber()
print(obj_1 + obj_2)
