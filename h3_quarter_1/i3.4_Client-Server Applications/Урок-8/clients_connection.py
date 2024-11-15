import os
import subprocess
import time

""" 
    Первым параметром передаваемым в списке Popen должно стоять правильное название 
    терминала в используемой системе.
    Например ['console', '-e'] или (['x-terminal-emulator', '-e'] для Ubuntu 22.04.1 LTS)
"""

PROCESS = []

while True:
    ACTION = input("Выберите действие: q - выход, "
                   "s - запустить сервер и клиенты, x - закрыть все окна: ")

    if ACTION == "q":
        break
    elif ACTION == "s":
        # запуск сервера
        args_server = f"{os.path.abspath('server.py')}"

        PROCESS.append(subprocess.Popen(["x-terminal-emulator", "-e", "python", args_server]))
        print(f"Запущен сервер - {args_server}")
        time.sleep(1)

        for sender in range(1):
            # запуск клиента для отправки сообщений
            args_sends_clients = f"{os.path.abspath('client.py')}"

            PROCESS.append(subprocess.Popen(["x-terminal-emulator", "-e", "python",
                                             args_sends_clients, "-m", "send"]))

            print(f"Запущен сендер № {sender + 1} - {args_sends_clients}")
            time.sleep(1)

        for listener in range(2):
            # запуск клиента для приема сообщений
            args_listens_clients = os.path.abspath('client.py')

            PROCESS.append(subprocess.Popen(["x-terminal-emulator", "-e", "python",
                                             args_listens_clients, "-m", "listen"]))
            
            print(f"Запущен слушатель № {listener + 1} - {args_listens_clients}")
            time.sleep(1)

    elif ACTION == "x":
        while PROCESS:
            VICTIM = PROCESS.pop()
            VICTIM.kill()
