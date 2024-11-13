import csv


#1  скопировать все-столбцы-n   handbook1.csv -> handbook1.csv
# with open("handbook1.csv", "r") as f1:
#     with open("handbook2.csv", "w") as f2:
#         f1_read = csv.DictReader(f1)
#         f2_writer = csv.DictWriter(f2, fieldnames=["hostname", "vendor", "model", "location"])
#         f2_writer.writeheader()
#         f2_writer.writerows(f1_read)


#2  скопировать строку-n    handbook1.csv -> handbook1.csv
n = int(input("Введите номер строки\n")) - 1
with open("handbook1.csv", "r") as f1:
    with open("handbook2.csv", "w") as f2:
        list_1 = list(csv.reader(f1))
        f2_writer = csv.writer(f2)
        f2_writer.writerow(list_1[n])


#3  записать данные из-переменной -> в-файл.
# data = [['hostname', 'vendor', 'model', 'location'],
#         ['kp1', 'Cisco', '2960', 'Moscow, str'],
#         ['kp2', 'Cisco', '2960', 'Novosibirsk, str'],
#         ['kp3', 'Cisco', '2960', 'Kazan, str'],
#         ['kp4', 'Cisco', '2960', 'Tomsk, str']]
# with open("handbook1.csv", "w") as f1:
#     f1_writer = csv.writer(f1)
#     f1_writer.writerows(data)