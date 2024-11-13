
#ПАРАМЕТРЫ
HOSTS = "localhost" #Адрес хоста, с которого принимаем соединение. Пустая строка - принимаем от любого хоста
PORT = 7777 #Номер порта для соединения
ENCODING="utf-8"
READCLIENT = "readclient" 
WHRITECLIENT = "writeclient"
NAME = 'name'


# КЛЮЧИ

BASIC_NOTICE = 100
OK = 200 #Связь устанволена
ACCEPTED = 202 #Сообщение принято успешно
WRONG_REQUEST = 400  # неправильный запрос/json объект
SERVER_ERROR = 500


# тип сообщения между клиентом и сервером
ACTION = 'action'
# время запроса
TIME = 'time'
# данные о пользователе - клиенте (вложенный словарь)
USER = 'user'
# имя пользователя - чата
ACCOUNT_NAME = 'account_name'
# код ответа
RESPONSE = 'response'
# текст ошибки
ERROR = 'error'

# ЗНАЧЕНИЯ
PRESENCE = 'presence'
MSG="message"
TO="to_account"
FROM="from_account"
SERVER="server"