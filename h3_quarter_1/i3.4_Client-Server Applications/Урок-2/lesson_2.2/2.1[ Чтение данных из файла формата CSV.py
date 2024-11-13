import csv


# построчный вывод
with open("2.1[.csv") as csv_1:
    for row in csv.reader(csv_1):
        print(row)


# csv -> [["row1"], ["row2"], ["row3"]]
with open("2.1[.csv") as csv_1:
    list_1 = list(csv.reader(csv_1))
    print(list_1)
    for row in list_1:
        print(row)


# 3. print([0] * 10 ** 9). Как убить компьютер ?
# print([el for el in range(10 ** 6)])


# отделить строки с заголовками от содержимого таблицы при выводе
with open("2.1[.csv") as csv_1:
    csv_1__headers = next(csv.reader(csv_1))
    print(csv_1__headers)
    for row in csv.reader(csv_1):
        print(row)


# метод DictReader модуля csv.
# вывод key:value
with open("2.1[.csv") as csv_1:
    for row in csv.DictReader(csv_1):
        print(row)


# выводить содержимое отдельных столбцов
with open("2.1[.csv") as csv_1:
    for row in csv.DictReader(csv_1):
        print(row["hostname"])