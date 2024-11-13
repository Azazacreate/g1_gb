"""Программа-клиент"""

import sys
import json
import socket
import time
import argparse
from common.variables import ACTION, PRESENCE, CURRENT_TIME, USER, ACCOUNT_NAME, \
    RESPONSE, ERROR, DEFAULT_IP_ADDRESS, DEFAULT_PORT, TIME, DICT_LOG_CONFIG
from common.utils import get_message, send_message
import logging
import logging.config
from deco import Log


class Client():
    """Программа-клиент"""
    address = ()
    client = None
    logger = None

    @Log()
    def start_client_logging(self):
        '''
        запуск логгирования работы клиента
        '''
        logging.config.dictConfig(DICT_LOG_CONFIG)
        self.logger = logging.getLogger("log_client")
        self.logger.info("Client logging started")

    @Log()
    def get_comand_prompt_parameters(self):
        '''
        разбираем параметры командной строки запуска сервера
        порты могут быть в диапазоне range(1024, 65536)

        :return: значения параметров сервера
        '''
        prompt_parameters = argparse.ArgumentParser()
        prompt_parameters.add_argument('a', default=DEFAULT_IP_ADDRESS, nargs='?')
        prompt_parameters.add_argument('p',
                                       choices=[
                                           str(x) for x in range(
                                               1024,
                                               65536)],
                                       default=DEFAULT_PORT, nargs='?')

        parameters_value = prompt_parameters.parse_args(sys.argv[1:])

        self.address = (parameters_value.a, int(parameters_value.p))

    @Log()
    def start_client(self):
        """Старт-клиент
        # client.py 127.0.0.1 7777
        """
        self.logger.debug(f'Starting the client at {CURRENT_TIME} с параметрами {self.address}')
        #print('Starting the client at', CURRENT_TIME)
        self.client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.client.connect(self.address)

    @Log()
    def listen_client(self):
        """Ждем-сервер"""
        message_to_server = self.create_presence()
        send_message(self.client, message_to_server)
        try:
            answer = self.process_ans(get_message(self.client))
            self.logger.debug(f'Получено сообщение от сервера: {answer}')
            #print(answer)
        except (ValueError, json.JSONDecodeError):
            self.logger.debug(f'Не удалось декодировать сообщение сервера.')
            #print('Не удалось декодировать сообщение сервера.')

    @Log()
    def create_presence(self, account_name='Guest'):
        '''
        Функция генерирует запрос о присутствии клиента
        :param account_name:
        :return:
        '''
        # {'action': 'presence', 'time': 1573760672.167031, 'user': {'account_name': 'Guest'}}
        out = {
            ACTION: PRESENCE,
            TIME: time.time(),
            USER: {
                ACCOUNT_NAME: account_name
            }
        }
        self.logger.debug(f'Сформирован запрос серверу, действие клиента: {PRESENCE}')
        return out

    @Log()
    def process_ans(self, message):
        '''
        Функция разбирает ответ сервера
        :param message:
        :return:
        '''
        if RESPONSE in message:
            if message[RESPONSE] == 200:
                return '200 : OK'
            return f'400 : {message[ERROR]}'
        raise ValueError


def main():
    '''Загружаем параметы коммандной строки'''
    # client.py 127.0.0.1 7777

    my_client = Client()
    my_client.start_client_logging()
    my_client.get_comand_prompt_parameters()
    my_client.start_client()
    my_client.listen_client()


if __name__ == '__main__':
    main()
