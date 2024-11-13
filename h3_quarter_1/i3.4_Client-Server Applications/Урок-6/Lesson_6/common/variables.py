"""Константы"""

from datetime import datetime
import sys

# текущее время для регистрации действий сервера
CURRENT_TIME = datetime.now()

# Порт поумолчанию для сетевого ваимодействия
DEFAULT_PORT = 7777
# IP адрес по умолчанию для подключения клиента
DEFAULT_IP_ADDRESS = '127.0.0.1'
# Максимальная очередь подключений
MAX_CONNECTIONS = 5
# Максимальная длинна сообщения в байтах
MAX_PACKAGE_LENGTH = 1024
# Кодировка проекта
ENCODING = 'utf-8'

# Прококол JIM основные ключи:
ACTION = 'action'
TIME = 'time'
USER = 'user'
ACCOUNT_NAME = 'account_name'

# Прочие ключи, используемые в протоколе
PRESENCE = 'presence'
RESPONSE = 'response'
ERROR = 'error'

# настройки логгеров
CLASS = "logging.FileHandler"
FORMATTER = "myFormatter"
ENCODING = "utf8"

DICT_LOG_CONFIG = {
    "version": 1,
    "handlers": {
        "client_FileHandler": {
            "class": CLASS,
            "formatter": FORMATTER,
            "filename": "logs/client_log/client.log",
            "encoding": ENCODING,
        },
        "server_FileHandler": {
            "class": 'logging.handlers.TimedRotatingFileHandler',
            "formatter": FORMATTER,
            "filename": "logs/server_log/server.log",
            "encoding": ENCODING,
            "interval": 1,
            "when": 'D',
        },
        "StreamHandler": {
            "class": "logging.StreamHandler",
            "formatter": FORMATTER,
            "stream": sys.stderr,
        },
    },
    "loggers": {
        "log_client": {
            "handlers": ["client_FileHandler", 'StreamHandler'],
            "level": "DEBUG",
        },
        "log_server": {
            "handlers": ["server_FileHandler", 'StreamHandler'],
            "level": "DEBUG",
        },
    },
    "formatters": {
        "myFormatter": {
            "format": '%(asctime)s %(levelname)s %(filename)s %(message)s'
        }
    }
}
