"""
Форматирование
"""

import sys
import logging

# Результат %()-9s соответствует
# операции {:<9} когда вы используете функцию format()

# длина слова
WORD = 'CRITICAL'
len(WORD)

# Правый отступ равен 8 - длина слово
# Таким образом, мы имеем 1 пробел между словом и решеткой
print('{:<15}#text'.format(WORD))

# Создать логгер и сравнить функцию format() и конструктор Formatter()
LOG = logging.getLogger('my_logger')
STREAM_HANDLER = logging.StreamHandler(sys.stdout)

FORMATTER = logging.Formatter('%(levelname)-15s#text')
STREAM_HANDLER.setFormatter(FORMATTER)

LOG.addHandler(STREAM_HANDLER)
LOG.setLevel(logging.CRITICAL)

LOG.critical('Критическое сообщение')
