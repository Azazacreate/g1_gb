"""
Служебный скрипт запуска/останова нескольких клиентских приложений
"""

from subprocess import Popen, CREATE_NEW_CONSOLE
from traceback import format_exc


P_LIST = []

while True:
    USER = input("Запустить 10 клиентов (s) / Закрыть клиентов (x) / Выйти (q) ")

    if USER == 'q':
        break

    elif USER == 's':
        for _ in range(3):
            try:
                p_obj = Popen('python time_client_random.py', creationflags=CREATE_NEW_CONSOLE)

            except Exception as e:
                print('Ошибка:\n', format_exc())
            else:
                P_LIST.append(p_obj)



        print(' Запущено 10 клиентов')
    elif USER == 'x':
        for p in P_LIST:
            p.kill()
        P_LIST.clear()

