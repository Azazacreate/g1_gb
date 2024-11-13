'''
Created on 25 мая 2019 г.
Новая ветка
@author: alex
'''
from socket import *
from jimServices import *
import sys
import traceback
import time
from errors import *
from log.client_log_config import *
from log.logDecor import *
import threading
from time import sleep


# функция формирования сообщения
@logClientDecor
def createPresence(account_name="Guest"):
    """
    Сформировать ​​presence-сообщение
    :param account_name: Имя пользователя
    :return: Словарь сообщения
    """
    # Если имя не строка
    if not isinstance(account_name, str):
        # Генерируем ошибку передан неверный тип
        raise TypeError
    # Если длина имени пользователя больше 25 символов
    if len(account_name) > 25:
        # генерируем нашу ошибку имя пользователя слишком длинное
        raise UsernameToLongError(account_name)
    # если все хорошо, то
    # формируем словарь сообщения
    message = {
        ACTION: PRESENCE,
        TIME: time.time(),
        USER: {
            ACCOUNT_NAME: account_name
        }
    }
    # возвращаем сообщение в виде словаря
    return message

def readMessages(clientSocket, clientName):
    while True:
        serverAnswer=getMessage(clientSocket)
        logClient.info(f"{clientName}: От сервера потоком получено сообщение {serverAnswer}")
        print(f"\n{serverAnswer[USER][ACCOUNT_NAME]} ({time.ctime(serverAnswer[TIME])}): {serverAnswer[MSG]}\n")
#        print("Введите сообщение >")

if __name__=="__main__":
    #Переводим ключи командной строки в словарь
    arg=getopts(sys.argv)

    print (f"Запуститли клиента с параметрами {arg} ")
    sock=socket(AF_INET,SOCK_STREAM)
    logClient.info("Запущен клиент")    
 
    
    try:
        sock.connect((arg["a"], arg["p"]))
        
        startMessage=createPresence(account_name=arg["name"])
        sendMessage(sock, startMessage)
        logClient.info(f"{arg['name']}: Серверу отправлено приветственное сообщение {startMessage}")
        serverAnswer=getMessage(sock)
        logClient.info(f"{arg['name']}: От сервера получен ответ на приветственноу сообщение {serverAnswer}")       
        
        if serverAnswer[RESPONSE]==OK:
            if READCLIENT in arg.values():    
                readThread = threading.Thread(target=readMessages, args=(sock,arg[NAME]))
                readThread.daemon=True
                readThread.start()


            
            while True:

                #Если мы НЕ слушающий клиент
                if READCLIENT not in arg.values():                
                    msg=input("Введите сообщение >").split()
                    
                    try:
                        toClient=msg[0]
                        msg=msg[1:]
                        msg=' '.join(msg)
                    except IndexError:
                        print("Неверный формат. Используйте формат('ИмяКлиента' Сообщение)")
                    else:
                        messageForSend=createMessage(msg, from_account=arg[NAME], to_account=toClient)
                        sendMessage(sock, messageForSend)
                        logClient.info(f"{arg['name']}:Серверу отправлено текстовое сообщение {messageForSend}")
#                        serverAnswer=getMessage(sock)
#                        logClient.info(f"{arg['name']}: От сервера получен ответ о верности принятия текстового сообщения {serverAnswer}")
        else:
            logClient.warning(f"Сервер отказал в подключении {serverAnswer}")
            print (f"Сервер отказал в подключении {serverAnswer}")      
          
    except ConnectionRefusedError:
        logClient.warning(f"Неудачная попытка подключения к серверу! \n Ошибка {traceback.format_exc()}")
        print ("Неудачная попытка подключения к серверу! \nОшибка")      

sock.close()

    
        
        