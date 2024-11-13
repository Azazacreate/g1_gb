""" Программа сервера для получения приветствия от клиента и отправки ответа """

from socket import socket, AF_INET, SOCK_STREAM

SERV_SOCK = socket(AF_INET, SOCK_STREAM)
#print(type(SERV_SOCK))
SERV_SOCK.bind(('', 8007))
SERV_SOCK.listen(5)

try:
    while True:
        CLIENT_SOCK, ADDR = SERV_SOCK.accept()
        # попробуйте уменьшить размер пакета и передать длинное сообщение
        # аргумент устанавливает максимальное количество байтов в сообщении.
        #  Если столько байт, сколько указано, не пришло, а
        #  какие-то данные уже появились, она всё равно возвращает всё, что имеется
        DATA = CLIENT_SOCK.recv(1024)
        print(f"Сообщение: {DATA.decode('utf-8')} было отправлено клиентом: {ADDR})")
        MSG = 'Привет, клиент'
        CLIENT_SOCK.send(MSG.encode('utf-8'))
        CLIENT_SOCK.close()
finally:
    SERV_SOCK.close()
