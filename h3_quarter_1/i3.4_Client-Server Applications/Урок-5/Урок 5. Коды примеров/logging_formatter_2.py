"""
Журналирование (логгирование) с использованием модуля logging
Расширенная настройка. Форматирование, обработчики
"""

import sys
import logging


# Создать логгер - регистратор верхнего уровня
# с именем basic
LOG = logging.getLogger('app.basic')

# Создать обработчик, который выводит сообщения в поток stderr
# обработчики позволяют переопределить поведение корневого регистратора - log
CRIT_HAND = logging.StreamHandler(sys.stderr)
# выводит в поток сообщения с уровнем CRITICAL

# Создать объект Formatter
# Определить формат сообщений
FORMATTER = logging.Formatter("%(levelname)-10s %(asctime)-30s %(message)s")

# подключить объект Formatter к обработчику
CRIT_HAND.setFormatter(FORMATTER)

# Добавить обработчик к регистратору
LOG.addHandler(CRIT_HAND)
LOG.setLevel(logging.INFO)

# Передать сообщение обработчику
LOG.info('Информационное сообщение')
