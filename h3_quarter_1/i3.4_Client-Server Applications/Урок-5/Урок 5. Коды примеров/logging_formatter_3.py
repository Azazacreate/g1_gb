"""
Журналирование (логгирование) с использованием модуля logging
Расширенная настройка. Форматирование, обработчики
"""

import logging

# 1. Создать логгер - регистратор верхнего уроовня
# с именем app.main
LOG = logging.getLogger('app.main')

# 2. Создать обработчик
FILE_HANDLER = logging.FileHandler("app.log", encoding='utf-8')
# выводит сообщения с уровнем DEBUG
FILE_HANDLER.setLevel(logging.CRITICAL)

# 3. Создать объект Formatter
# Определить формат сообщений
FORMATTER = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")

# 4. подключить объект Formatter к обработчику
FILE_HANDLER.setFormatter(FORMATTER)

# 5. Добавить обработчик к регистратору
LOG.addHandler(FILE_HANDLER)
LOG.setLevel(logging.DEBUG)

# Передать сообщение обработчику
LOG.info('Информационное сообщение')
#LOG.debug("отладка")
#LOG.warning('warning')
#LOG.error('error')
#LOG.critical('critical')
