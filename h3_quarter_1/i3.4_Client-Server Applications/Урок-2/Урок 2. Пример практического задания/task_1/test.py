'''Создать телефонный справочник с
возможностью импорта и экспорта данных в
формате .txt. Фамилия, имя, отчество, номер
телефона - данные, которые должны находиться
в файле.
1. Программа должна выводить данные
2. Программа должна сохранять данные в
текстовом файле
3. Пользователь может ввести одну из
характеристик для поиска определенной
записи(Например имя или фамилию
человека)
4. Использование функций. Ваша программа
не должна быть линейной'''

from os.path import exists
from csv import DictReader, DictWriter


def get_info():
    info = []
    first_name = 'Ivan'
    last_name = 'Ivanov'
    info.append(first_name)
    info.append(last_name)
    flag = False
    while not flag:
        try:
            phone_number = 12345678901  # int(input('Введите номер телефона: '))
            if len(str(phone_number)) != 11:
                print('wrong number')
            else:
                flag = True
        except ValueError:
            print('not valid number')
    info.append(phone_number)
    return info


def create_file():
    with open('phone.csv', 'w', encoding='utf-8') as data:
        # data.write('Фамилия;Имя;Номер\n')
        f_n_writer = DictWriter(data, fieldnames=['Фамилия', 'Имя', 'Номер'])
        f_n_writer.writeheader()


def write_file(lst):
    # with open('phone.txt', 'a', encoding='utf-8') as data:
    #     data.write(f'{lst[0]};{lst[1]};{lst[2]}\n')
    with open('phone.csv', 'r+', encoding='utf-8') as f_n:
        f_n_reader = DictReader(f_n)
        res = list(f_n_reader)
        obj = {'Фамилия': lst[0], 'Имя': lst[1], 'Номер': lst[2]}
        res.append(obj)
        f_n_writer = DictWriter(f_n, fieldnames=['Фамилия', 'Имя', 'Номер'])
        for el in res:
            f_n_writer.writerow(el)


def read_file(file_name):
    # with open(file_name, encoding='utf-8') as data:
    #     phone_book = data.readlines()
    with open(file_name, encoding='utf-8') as f_n:
        f_n_reader = DictReader(f_n)
        phone_book = list(f_n_reader)
    return phone_book


def record_info():
    lst = get_info()
    write_file(lst)


def main():
    while True:
        command = input('Введите команду: ')
        if command == 'q':
            break
        elif command == 'r':
            if not exists('phone.csv'):
                print('Файл не создан')
                break
            print(*read_file('phone.csv'))
        elif command == 'w':
            if not exists('phone.csv'):
                create_file()
                record_info()
            else:
                record_info()


main()