"""__lt__"""


class Salary:
    val = 50000

    def __eq__(self, other):
        print("Оклад меньше премии?")
        return self.val < other.val


class Prize:
    val = 5000

    def __lt__(self, other):
        print("Премия меньше оклада?")
        return self.val < other.val


s = Salary()
p = Prize()

check = s > p
print(check)

"""
Оклад меньше премии?
False
"""
