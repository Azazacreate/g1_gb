"""Декораторы"""

import sys
import os
import logging

# Реализация в виде класса


class Log:
    """Класс-декоратор"""
    logger = None

    def __call__(self, func_to_log):
        def logger_start(self, module_name):
            """Запускаем логгер"""
            if module_name.find('client') == -1:
                # если не клиент то сервер!
                self.logger = logging.getLogger('log_server')
            else:
                # ну, раз не сервер, то клиент
                self.logger = logging.getLogger('log_client')

        def get_logged_function_module_and_start_function_name():
            """Фиксация функции, из которой была вызвана декорированная и
            имя модуля из которого она запущена"""
            return {'name': sys._getframe(2).f_code.co_name,
                    'module': os.path.basename(sys.argv[0])}

        def log_saver(*args, **kwargs):
            """Обертка"""
            func_to_log_info = get_logged_function_module_and_start_function_name()
            f_name = func_to_log_info['name']
            f_module = func_to_log_info['module']

            logger_start(self, f_module)

            ret = func_to_log(*args, **kwargs)
            self.logger.debug(
                f'Была вызвана функция \"{func_to_log.__name__}\" c параметрами '
                f'\"{args}, {kwargs}\". '
                f'Вызов произошел из функции \"{f_name}\" модуля \"{f_module}\".')
            return ret
        return log_saver
