"""Программа-клиент"""

import sys
import json
import socket
import time
from common.settings import ACTION, PRESENCE, TIME, USER, NAME, \
    RESPONSE, ERROR, DEFAULT_SERVER_IP, DEFAULT_SERVER_PORT
from common.utils import get_dict_message, send_json_string


def create_client(name='Guest'):
    """
    Функция генерирует запрос о присутствии клиента
    """
    out = {
        ACTION: PRESENCE,
        TIME: time.time(),
        USER: {
            NAME: name
        }
    }  # формирование словаря
    return out  # возвращаем сформированный словарь


def give_status_message(dict_message):
    """
    Функция принимает на вход словарь и возвращает ответ
    """
    if RESPONSE in dict_message:  # проверка что во входном словаре присутствует 'response'
        if dict_message[RESPONSE] == 200:  # проверка что значение кода 200
            return '200 : OK'  # возвращаем код 200
        return f'400 : {dict_message[ERROR]}'  # иначе возвращаем код 400 error
    raise ValueError  # отлавливаем ошибку если в словаре нет 'response'


def main():
    """
    Загружаем параметы коммандной строки
    Создаем сокет, подключаемя к серверу и формируем запрос на сервер
    Разбираем ответ от сервера и информируем клиента
    """
    try:
        server_address = sys.argv[1]  # первым параметром задаем ip адрес сервера
        server_port = int(sys.argv[2])  # вторым параметром задаем порт сервера
        if server_port < 1024 or server_port > 65535:  # проверяем что указанный порт в нужном диапозоне
            raise ValueError
    except IndexError:  # отлавливаем ошибку и задаем параметры ip адрес и порт сервера по умолчанию из settings
        server_address = DEFAULT_SERVER_IP
        server_port = DEFAULT_SERVER_PORT
    except ValueError:  # отлавливаем ошибку и информируем
        print('В качестве порта может быть указано только число в диапазоне от 1024 до 65535.')
        sys.exit(1)

    SOCKET_CLIENT = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  # создаем клиентский сокет
    SOCKET_CLIENT.connect((server_address, server_port))  # подключаемся к серверу
    message_to_server = create_client()  # получаем работу функции create_client
    send_json_string(SOCKET_CLIENT, message_to_server)  # получаем работу функции send_json_string
    try:
        status_code_message = give_status_message(get_dict_message(SOCKET_CLIENT))  # получаем работу функции
        # give_status_message
        print(status_code_message)  # информируем в консоль
    except (ValueError, json.JSONDecodeError):  # отлавливаем ошибку о неудачи декодировать сообщение
        print('Не удалось декодировать сообщение сервера.')  # информируем в консоль


if __name__ == '__main__':
    main()
