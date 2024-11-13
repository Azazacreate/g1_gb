class Road:
    weight = 25  # Масса
    thickness = 0.05  # Толщина

    def __init__(self, length, width):
        self._length = length
        self._width = width

    def method(self):
        b = Road.weight * Road.thickness * self._length * self._width
        return b


a = Road(20, 5000)
c = a.method()
print(f"Асфальта понадобится - {int(c)} кг или {int((c) / 1000)} тонн")