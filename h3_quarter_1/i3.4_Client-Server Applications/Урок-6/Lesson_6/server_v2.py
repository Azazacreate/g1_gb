"""Программа-сервер"""

import socket
import json
import argparse
import sys
from common.variables import ACTION, ACCOUNT_NAME, RESPONSE, MAX_CONNECTIONS, \
    PRESENCE, CURRENT_TIME, USER, ERROR, DEFAULT_PORT, DEFAULT_IP_ADDRESS, TIME, DICT_LOG_CONFIG
from common.utils import get_message, send_message
import logging
import logging.config
from deco import Log


class Server():
    """Программа-сервер"""
    port_number = None
    addres_number = None
    server = None
    logger = None

    @Log()
    def start_server_logging(self):
        '''
        запуск логгирования работы сервера
        '''
        logging.config.dictConfig(DICT_LOG_CONFIG)
        self.logger = logging.getLogger("log_server")
        self.logger.info("Server logging started")

    @Log()
    def get_comand_prompt_parameters(self):
        '''
        разбираем параметры командной строки запуска сервера
        порты могут быть в диапазоне range(1024, 65536)

        :return: значения параметров сервера
        '''
        prompt_parameters = argparse.ArgumentParser()
        prompt_parameters.add_argument(
            '-p',
            choices=[
                str(x) for x in range(
                    1024,
                    65536)],
            default=DEFAULT_PORT)
        prompt_parameters.add_argument('-a', default=DEFAULT_IP_ADDRESS)

        parameters_value = prompt_parameters.parse_args(sys.argv[1:])

        self.port_number = parameters_value.p
        self.addres_number = parameters_value.a

    @Log()
    def start_server(self):
        """Старт-сервер"""
        self.logger.debug(
            f'Starting the server at {CURRENT_TIME},\nWaiting for a client to call.')
        #print('Starting the server at', CURRENT_TIME)
        #print('Waiting for a client to call.')
        self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server.bind((self.addres_number, self.port_number))

    @Log()
    def listen_server(self):
        """Ждем-клиента"""
        self.server.listen(MAX_CONNECTIONS)

        while True:
            client, client_address = self.server.accept()
            try:
                message_from_cient = get_message(client)
                self.logger.debug(
                    f'At: {CURRENT_TIME} client: {client}')
                #print('At', CURRENT_TIME, client, 'said', message_from_cient)
                # {'action': 'presence', 'time': 1573760672.167031, 'user':
                # {'account_name': 'Guest'}}
                response = self.process_client_message(message_from_cient)
                send_message(client, response)
                client.close()
            except (ValueError, json.JSONDecodeError):
                self.logger.debug(f'Принято некорретное сообщение от клиента.')
                #print('Принято некорретное сообщение от клиента.')
                client.close()

    @Log()
    def process_client_message(self, message):
        '''
        Обработчик сообщений от клиентов, принимает словарь -
        сообщение от клинта, проверяет корректность,
        возвращает словарь-ответ для клиента

        :param message:
        :return:
        '''

        self.logger.debug(f'Получено сообщение от клиента : {message}')
        if ACTION in message and message[ACTION] == PRESENCE and TIME in message \
                and USER in message and message[USER][ACCOUNT_NAME] == 'Guest':
            return {RESPONSE: 200}
        return {
            RESPONSE: 400,
            ERROR: 'Bad Request'
        }


def main():
    '''
    Запуск сервера. Вид командной строки:
    server.py -p 8079 -a 192.168.1.2

    Параметры не обязательны

    :return:
    '''

    my_server = Server()
    my_server.start_server_logging()
    my_server.get_comand_prompt_parameters()
    my_server.start_server()
    my_server.listen_server()


if __name__ == '__main__':
    main()
