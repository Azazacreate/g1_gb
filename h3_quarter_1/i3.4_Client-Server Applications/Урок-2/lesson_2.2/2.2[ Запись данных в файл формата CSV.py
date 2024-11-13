import csv


# 1 записать список строк в-файл
data = [['hostname', 'vendor', 'model', 'location'],
        ['kp1', 'Cisco', '2960', 'Moscow, str'],
        ['kp2', 'Cisco', '2960', 'Novosibirsk, str'],
        ['kp3', 'Cisco', '2960', 'Kazan, str'],
        ['kp4', 'Cisco', '2960', 'Tomsk, str']]

with open('kp_data_write.csv', 'w') as f_n:
    f_n_writer = csv.writer(f_n)
    for row in data:
        f_n_writer.writerow(row)

with open('kp_data_write.csv') as f_n:
    print(f_n.read())


# 2. Считается хорошей практикой явное указание кавычек для каждого значения.
# можно-определять:программно такую опцию
data = [['hostname', 'vendor', 'model', 'location'],
        ['kp1', 'Cisco', '2960', 'Moscow, str'],
        ['kp2', 'Cisco', '2960', 'Novosibirsk, str'],
        ['kp3', 'Cisco', '2960', 'Kazan, str'],
        ['kp4', 'Cisco', '2960', 'Tomsk, str']]

with open('kp_data_write_2.csv', 'w') as f_n:
    f_n_writer = csv.writer(f_n, quoting=csv.QUOTE_NONNUMERIC)
    for row in data:
        f_n_writer.writerow(row)

with open('kp_data_write_2.csv') as f_n:
    print(f_n.read())


# writerows() - записать:мгновенно все-данные.
data = [['hostname', 'vendor', 'model', 'location'],
        ['kp1', 'Cisco', '2960', 'Moscow, str'],
        ['kp2', 'Cisco', '2960', 'Novosibirsk, str'],
        ['kp3', 'Cisco', '2960', 'Kazan, str'],
        ['kp4', 'Cisco', '2960', 'Tomsk, str']]

with open('kp_data_write_3.csv', 'w') as f_n:
    f_n_writer = csv.writer(f_n, quoting=csv.QUOTE_NONNUMERIC)
    f_n_writer.writerows(data)

with open('kp_data_write_3.csv') as f_n:
    print(f_n.read())


# если данные в файле разделены с помощью «!», можно указать модулю csv использовать именно восклицательный знак при разделении данных
with open('kp_data_delimiter.csv') as f_n:
    for row in csv.reader(f_n, delimiter='!'):
        print(row)
