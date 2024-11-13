"""
Задание 6.

Реализовать структуру данных «Товары». Она должна представлять собой список кортежей.
Каждый кортеж хранит информацию об отдельном товаре.
В кортеже должно быть два элемента — номер товара и словарь с параметрами
(характеристиками товара: название, цена, количество, единица измерения).
Структуру нужно сформировать программно, т.е. запрашивать все данные у пользователя.

Пример готовой структуры:
[
    (1, {“название”: “компьютер”, “цена”: 20000, “количество”: 5, “eд”: “шт.”}),
    (2, {“название”: “принтер”, “цена”: 6000, “количество”: 2, “eд”: “шт.”}),
    (3, {“название”: “сканер”, “цена”: 2000, “количество”: 7, “eд”: “шт.”})
]

Далее необходимо собрать аналитику о товарах. Реализовать словарь,
в котором каждый ключ — характеристика товара, например название,
а значение — список значений-характеристик, например список названий товаров.

Пример:

{
“названия”: [“компьютер”, “принтер”, “сканер”],
“цены”: [20000, 6000, 2000],
“количества”: [5, 2, 7],
“ед”: [“шт.”, “шт.”, “шт.”]
}
"""

my_lst = []
while True:
    my_lst.append((input("Номер товара: "),
                   {"Название": input("Название: "),
                    "Цена": input("Цена: "),
                    "Количество": input("Количество: "),
                    "ед.": input("Единицы учёта: ")}))
    q = input("Закончить ввод позиций? Да, Нет: ")
    if q == "Да":
        break

my_lst = [(1, {"название": "компьютер", "цена": 20000, "количество": 5, "eд": "шт."}),
          (2, {"название": "принтер", "цена": 6000, "количество": 2, "eд": "шт."}),
          (3, {"название": "сканер", "цена": 2000, "количество": 7, "eд": "шт."})]

names_lst = []
prices_lst = []
counts_lst = []
units_lst = []
res_dict = {}
for i in range(len(my_lst)):
    names_lst.append(my_lst[i][1]['название'])
    prices_lst.append(my_lst[i][1]['цена'])
    counts_lst.append(my_lst[i][1]['количество'])
    units_lst.append(my_lst[i][1]['eд'])

res_dict.update({'названия': names_lst, 'цены': prices_lst, 'количества': counts_lst, 'единицы': units_lst})
print(res_dict)
