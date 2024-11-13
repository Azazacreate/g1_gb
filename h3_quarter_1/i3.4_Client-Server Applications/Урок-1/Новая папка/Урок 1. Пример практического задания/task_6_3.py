"""
6. Создать текстовый файл test_file.txt, заполнить его тремя строками:
«сетевое программирование», «сокет», «декоратор».
Проверить кодировку файла по умолчанию.
Принудительно открыть файл в формате Unicode и вывести его содержимое.
"""

from chardet import detect

LINES_LST = ['сетевое программирование', 'сокет', 'декоратор']
with open('test.txt', 'w') as file:
    for line in LINES_LST:
        file.write(f'{line}\n')
file.close()

def encoding_convert():
    with open('test.txt', 'rb') as f:
        content_bytes = f.read()
    detected = detect(content_bytes)
    encoding = detected['encoding']
    content_text = content_bytes.decode(encoding)
    with open('test.txt', 'w', encoding='utf-8') as f:
        f.write(content_text)

encoding_convert()

# открываем файл в правильной кодировке
with open('test.txt', 'r', encoding='utf-8') as file:
    CONTENT = file.read()
print(CONTENT)
