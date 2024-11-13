class Auto:
    # атрибуты класса
    auto_name = "Lexus"
    auto_model = "RX 350L"
    auto_year = 2019

    # методы класса
    def on_auto_start(self):
        print(f"Заводим автомобиль")

    def on_auto_stop(self):
        print("Останавливаем работу двигателя")


a = Auto()
print(a)
print(type(a))
print(a.auto_name)
a.on_auto_start()
a.on_auto_stop()
