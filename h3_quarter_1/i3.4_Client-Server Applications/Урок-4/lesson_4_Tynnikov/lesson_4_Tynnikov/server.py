import json
import socket
import sys

from common import utils
from common.variables import ACTION, TIME, PRESENCE, USER, ACCOUNT_NAME, RESPONSE, ERROR, DEFAULT_PORT, MAX_CONNECTION


def process_client_message(message):
    """
    Обработчик сообщений от клиентов, принимает словарь - сообщение от клинта,
    проверяет корректность,возвращает словарь-ответ для клиента.
    :param message:
    :return:
    """

    if ACTION in message and message[ACTION] == PRESENCE and TIME in message \
            and USER in message and message[USER][ACCOUNT_NAME] == 'Guest':
        return {RESPONSE: 200}
    return {
        RESPONSE: 400,
        ERROR: 'Bad Request'
    }


def get_listen_port():
    """
    Проверка параметра, если порта нет используется дефолтное значение.
    :return: Порт
    """

    try:
        if '-p' in sys.argv:
            listen_port = int(sys.argv[sys.argv.index('-p') + 1])
            if listen_port < 1024 or listen_port > 65535:
                raise ValueError
        else:
            listen_port = DEFAULT_PORT
        return listen_port
    except IndexError:
        print('После параметра -\'p\' необходимо указать номер порта.')
        sys.exit(1)
    except ValueError:
        print('В качастве порта может быть указано только число в диапазоне от 1024 до 65535.')
        sys.exit(1)


def get_listen_address():
    """
    Проверка параметра с ip-адресом.
    :return: ip-address
    """

    try:
        if '-a' in sys.argv:
            listen_address = sys.argv[sys.argv.index('-a') + 1]
        else:
            listen_address = ''
        return listen_address
    except IndexError:
        print('После параметра \'a\'- необходимо указать адрес, который будет слушать сервер.')
        sys.exit(1)


def main():
    """
    Загрузка параметров командной строки, если нет параметров, то задаём значения по умоланию.
    Настройка пайчарм конфига для server.py -p 8079 -a 192.168.0.113
    :return: None
    """

    listen_port = get_listen_port()
    listen_address = get_listen_address()

    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind((listen_address, listen_port))  # привязать сокет к IP-адресу и порту машины
    server_socket.listen(MAX_CONNECTION)  # просигнализировать о готовности принимать соединения

    while True:
        client, client_address = server_socket.accept()
        try:
            message_from_cient = utils.get_message(client)
            print(message_from_cient)  # {'action': 'presence', 'time': 1573760672.167031, 'user': {'account_name': 'Guest'}}
            response = process_client_message(message_from_cient)
            utils.send_message(client, response)
            client.close()
        except (ValueError, json.JSONDecodeError):
            print('Принято некорретное сообщение от клиента.')
            client.close()


if __name__ == '__main__':
    main()
