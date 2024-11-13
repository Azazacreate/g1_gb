"""Модуль file_system"""

# получаем кодировку для файла, с которым работаем
#F_N = open('test.txt.txt', 'w') #cp1251
#F_N.write('привет')
#F_N.close()
#print(type(F_N))

# явное указание кодировки при работе с файлом
with open('test.txt', encoding='utf-8') as f_n:
    for el_str in f_n:
        print(el_str, end='')


# УЗНАТЬ КОДИРОВКУ ФАЙЛА
# перекодировать, rb
# chardet
# dict -> json -> bytes
# cp1251