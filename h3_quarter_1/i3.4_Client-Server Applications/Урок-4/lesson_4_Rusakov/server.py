import socket
import sys
import json
from common.settings import ACTION, NAME, RESPONSE, CONNECTION_QUEUE, PRESENCE, TIME, USER, ERROR, DEFAULT_SERVER_PORT
from common.utils import get_dict_message, send_json_string


def send_message_client(message):
    """
    Функция принимает на вход словарь, возвращает словарь
    """
    if ACTION in message and message[ACTION] == PRESENCE and TIME in message and USER in message and \
            message[USER][NAME] == 'Guest':  # проверка корректности сообщения,
        # проверяет все ключи полученного словаря на соответствие
        return {RESPONSE: 200}  # возвращает словарь с кодом 200, если входной словрь прошел проверку
    return {
        RESPONSE: 400,
        ERROR: 'Bad Request'
    }  # возвращает словаь с кодом 400, если входной словарь не прошел проверку


def main():
    """
    Функиця обрабатывает заданные флаги -p (Порт) -а (IP адрес) для запуска сервера, если пораметры не заданы,
    то они устанавоиваются по умолчанию из settings.py
    """
    try:
        if '-p' in sys.argv:  # проверяем задан ли флаг -p
            port_listning = int(sys.argv[sys.argv.index('-p') + 1])  # если задан то слушаем этот порт
        else:
            port_listning = DEFAULT_SERVER_PORT  # если не задан флаг -p, то используем порт по умолчанию
        if port_listning < 1024 or port_listning > 65535:  # проверяем что заданный порт не менее 1024 и не более 65535
            raise ValueError
    except IndexError:  # отлавливаем ошибку, если после флага -p ничего не написано
        print('После параметра -\'p\' необходимо указать номер порта.')
        sys.exit(1)
    except ValueError:  # отлавливаем ошибку, если задан не правильный диапазон
        print(
            'В качастве порта может быть указано только число в диапазоне от 1024 до 65535.')
        sys.exit(1)

    try:
        if '-a' in sys.argv:  # проверяем задан ли флаг -a
            address_listning = sys.argv[sys.argv.index('-a') + 1]  # если задан то слушаем этот адрес
        else:
            address_listning = ''  # если не задан флаг -а, то слушаем все адреса

    except IndexError:  # отлавливаем ошибку, если после флага -а ничего не написано
        print(
            'После параметра \'a\'- необходимо указать адрес, который будет слушать сервер.')
        sys.exit(1)

    SOCKET_SERVER = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  # создаем сокет сетевой TCP
    SOCKET_SERVER.bind((address_listning, port_listning))  # связываем сокет с хостом методом bind
    SOCKET_SERVER.listen(CONNECTION_QUEUE)  # слушаем порт

    while True:  # запуск сервера в бесконечном цикле
        socket_bytes, client_address = SOCKET_SERVER.accept()  # принимаем запрос на соединение
        try:
            get_message_from_client = get_dict_message(socket_bytes)  # получаем работу функции get_dict_message
            print(get_message_from_client)  # вывозим сообщение в консоль

            response = send_message_client(get_message_from_client)  # получаем работу функции send_message_client
            send_json_string(socket_bytes, response)  # получаем работу функции send_json_string
            socket_bytes.close()  # закрываем сокет
        except (ValueError, json.JSONDecodeError):  # отлавливаем и обрабатываем ошибку
            print('Принято некорретное сообщение от клиента.')
            socket_bytes.close()  # закрываем сокет


if __name__ == '__main__':
    main()
