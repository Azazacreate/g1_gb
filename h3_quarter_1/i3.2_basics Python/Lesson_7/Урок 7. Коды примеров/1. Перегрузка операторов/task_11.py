"""__iadd__"""


class MyClass:
    def __init__(self, val):
        self.val = val

    def __iadd__(self, other):
        self.val += other
        return self


mc = MyClass(100)
print(mc.val)
mc += 200
print(mc.val)


"""
100
300
"""
