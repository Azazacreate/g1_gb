import csv
from csv import DictWriter, DictReader
from os.path import exists
# import shutil


class Error_name(Exception):
    def __init__(self, txt):
        self.txt = txt


def get__data():
    flag = False
    while flag == False:
        try:
            nameFirst = input("Введите nameFirst:\n")
            if len(nameFirst) < 2:
                raise Error_name("Error. nameFirst is very-short!")
        except Error_name as err:
            print(err)
        else:
            flag = True
    nameLast = "Ivanov"
    phone = "89683332200"
        # дальше Вы можете-сделать валидацию на-тип__данных.
        # т.е проверить , чтобы пользователь ввел число, а не-строку.
    return [nameFirst, nameLast, phone]
def create__file(file_name):
    with open(file_name, "w", encoding="utf-8") as data:
        f_w = DictWriter(data, fieldnames=["Name", "Name_second", "Phone"])
        f_w.writeheader()   # заголовок


def read__file(file_name):
    with open(file_name, "r", encoding="utf-8") as data:
        f_r = DictReader(data)
        return list(f_r)


def write__file(file_name, list_1):
    box_1 = read__file(file_name)
    object_1 = {"Name":list_1[0], "Name_second": list_1[1], "Phone": list_1[2]}
    box_1.append(object_1)
    with open(file_name, "w", encoding="utf-8") as data:
        f_w = DictWriter(data, fieldnames=["Name", "Name_second", "Phone"])
        f_w.writeheader()  # заголовок
        f_w.writerows(box_1)

def delete__row(file_name):
    n = int(input("Введите номер_строки, которую Вы хотите удалить.\n")) - 1
    f1__read = read__file(file_name)
    f1__read.pop(n)
    with open(file_name, "w") as f1:
        f1_writer = DictWriter(f1, fieldnames=["Name", "Name_second", "Phone"])
        f1_writer.writeheader()
        f1_writer.writerows(f1__read)


def search__row(file_name):
    nameLast = input("Input your nameLast: ")
    box_1 = read__file(file_name)
    for row in box_1:
        if nameLast == row["Name_second"]:
            return row
    return "Запись не-найдена."


def copy(file_name):
    n = int(input("Введите номер строки\n")) - 1
    with open(file_name, "r") as f1:
        with open("phone2.csv", "w") as f2:
            list_1 = list(csv.reader(f1))
            f2_writer = csv.writer(f2)
            f2_writer.writerow(list_1[n])


def write_standart(file_name, f1__read):
    with open(file_name, "w") as f1:
        f1_writer = DictWriter(f1, fieldnames=["Name", "Name_second", "Phone"])
        f1_writer.writeheader()
        f1_writer.writerows(f1__read)


# def change__row(file_name):
#     row_number = int(input("Input row_number:\n"))
#     r2 = read__file(file_name)
#     data = get__data()
#     r2[row_number - 1]["Name"] = data[0]
#     r2[row_number - 1]["Name_second"] = data[1]
#     r2[row_number - 1]["Phone"] = data[2]
#     write_standart(file_name, r2)


def main():
    while True:
        command = input("Input your command: \n" + "write /delete / read /find /copy /change /create\n")
        if command == "quit":
            break
        elif command == "write":
            if not exists(file_name):
                create__file(file_name)
            write__file(file_name, get__data())
        elif command == "delete":
            delete__row(file_name)
        elif command == "read":
            if not exists(file_name):
                print("File doesn't exist. You must create file.")
                continue
            print(read__file(file_name))
        elif command == "find":
            if not exists(file_name):
                print("File doesn't exist. You must create file.")
                continue
            print(search__row(file_name))
        elif command == "copy":
            if not exists(file_name):
                print("File doesn't exist. You must create file.")
                # shutil.copy('phone.csv', 'handbook2.csv')
                continue
            copy(file_name)
        # elif command == "change":
        #     if not exists(file_name):
        #         print("File doesn't exist. You must create file.")
        #         continue
        #     change__row(file_name)


file_name = "phone.csv"
main()