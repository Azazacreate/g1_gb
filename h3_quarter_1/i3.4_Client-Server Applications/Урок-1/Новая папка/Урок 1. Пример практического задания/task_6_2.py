"""
6. Создать текстовый файл test_file.txt, заполнить его тремя строками:
«сетевое программирование», «сокет», «декоратор».
Проверить кодировку файла по умолчанию.
Принудительно открыть файл в формате Unicode и вывести его содержимое.
"""

from chardet.universaldetector import UniversalDetector

LINES_LST = ['сетевое программирование', 'сокет', 'декоратор']
with open('test.txt', 'w') as file:
    for line in LINES_LST:
        file.write(f'{line}\n')
file.close()

# узнаем кодировку файла

"""
Если файл имеет большой размер, то вместо считывания его целиком в строку 
и использования функции detect() можно воспользоваться классом UniversalDetector. 
В этом случае можно читать файл построчно и передавать текущую строку методу feed(). 
Если определение кодировки прошло успешно, атрибут done будет иметь значение True. 
Это условие можно использовать для выхода из цикла. 
После окончания проверки следует вызвать метод close(). 
Получить результат определения кодировки позволяет атрибут result
"""

DETECTOR = UniversalDetector()
with open('test.txt', 'rb') as test_file:
    for i in test_file:
        DETECTOR.feed(i)
        if DETECTOR.done:
            break
    DETECTOR.close()
print(DETECTOR.result['encoding'])

# открываем файл в правильной кодировке
with open('test.txt', 'r', encoding=DETECTOR.result['encoding']) as file:
    CONTENT = file.read()
print(CONTENT)
