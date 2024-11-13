"""
6. Создать текстовый файл test_file.txt, заполнить его тремя строками:
«сетевое программирование», «сокет», «декоратор».
Проверить кодировку файла по умолчанию.
Принудительно открыть файл в формате Unicode и вывести его содержимое.
"""

import sys
from _locale import _getdefaultlocale
_getdefaultlocale = (lambda *args: ['en_US', 'utf8'])

LINES_LST = ['сетевое программирование', 'сокет', 'декоратор']
with open('test.txt', 'w') as file:
    for line in LINES_LST:
        file.write(f'{line}\n')
file.close()

# открываем файл в правильной кодировке
with open('test.txt', 'r') as file:
    CONTENT = file.read()
print(CONTENT)
