"""
Фамилия     Имя         Часов   Ставка
Иванов      Иван        45      400
Докукин     Филимон     20      1000
Ромашкин    Сидор       45      500
"""

from collections import namedtuple


Salary = namedtuple('Salary', ('surname', 'name', 'worked', 'rate'))

# Иванов Иван 45 400
def get_salary(line):
    """
    Вычисление зарплаты работника
    """
    line = line.split()

    if line:
        data = Salary(*line)
        # data -> Salary(surname='Лютиков', name='Руслан', worked='60', rate='1000')
        fio = ' '.join((data.name, data.surname))
        salary = int(data.worked) * int(data.rate)
        res = (fio, salary)
        # res -> ('Лютиков Руслан', 60000)
    else:
        res = ()
    return res


arr = []
def decor(func):
    def wrap(*args, **kwargs):
        arr.append(func)
    return wrap

def res_1():
    for el in arr:
        el()



# 1- передать входные данные
# мы знаем как ф-ция на должна отреагировать
# сраванием как есть с тем как должно быть


@decor
def test_get_salary_summ():
    """тест 1"""
    assert get_salary('Лютиков Руслан 60 1000')[1] == 60000, 'Неверная сумма'

@decor
def test_get_salary_fio():
    """тест 2"""
    assert get_salary('Лютиков Руслан 60 1000')[0] == 'Руслан Лютиков', 'Неверное имя'


@decor
def test_get_salary_empty():
    """тест 3"""
    assert get_salary('') == (), 'Непустые данные'


if __name__ == "__main__":
    res_1()

