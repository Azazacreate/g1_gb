"""
2. Реализовать функцию, принимающую несколько параметров,
описывающих данные пользователя:
имя, фамилия, год рождения, город проживания, email, телефон.
Функция должна принимать параметры как именованные аргументы.
Реализовать вывод данных о пользователе одной строкой.

Пример: Иван Иванов 1846 года рождения, проживает в городе Москва,
email: jackie@gmail.com, телефон: 01005321456
"""


def user_info(**kwargs):
    print(f"{kwargs['name']} {surname} {year_of_birth} года рождения, "
          f"проживает в городе {city}, email: {email}, телефон: {phone}")


user_info(
    name="Иван",
    surname="Иванов",
    year_of_birth="1846",
    city="Москва",
    email="jackie@gmail.com",
    phone="01005321456"
)
