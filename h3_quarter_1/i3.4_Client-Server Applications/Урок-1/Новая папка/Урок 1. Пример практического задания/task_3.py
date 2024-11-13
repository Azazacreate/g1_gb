"""
3. Определить, какие из слов «attribute», «класс», «функция», «type»
невозможно записать в байтовом типе.
"""

# Префикс 'b' создает экземпляр типа байтов вместо типа str.
# Они могут содержать только символы ascii

VAR_1 = 'attribute'
VAR_2 = 'класс'
VAR_3 = 'функция'
VAR_4 = 'type'

VAR_LIST = [VAR_1, VAR_2, VAR_3, VAR_4]

# Вариант 1
for el in VAR_LIST:
    try:
        bytes(el, 'ascii')
    except UnicodeEncodeError:
        print(f'Слово "{el}" невозможно записать в виде байтовой строки')

# Вариант 2
for el in VAR_LIST:
    try:
        el.encode('ascii')
    except UnicodeEncodeError:
        print(f'Слово "{el}" невозможно записать в виде байтовой строки')

# Вариант 3
for el in VAR_LIST:
    try:
        expr_obj = f"b'{el}'"
        exec(expr_obj)
    except SyntaxError:
        print(f'Слово "{el}" невозможно записать в виде байтовой строки')

# Вариант 4
for el in VAR_LIST:
    if ord(el[0]) > 255:
        print(f'Слово "{el}" невозможно записать в виде байтовой строки')
