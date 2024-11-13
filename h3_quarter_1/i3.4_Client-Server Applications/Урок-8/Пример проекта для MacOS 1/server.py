#! /usr/bin/env python
# -*- coding: utf-8 -*-
'''

Параметры командной строки:
-a адрес хоста, с которого приниаются соединения (all - соединения принимаются с любого хоста)
-p номер порта

'''
from sys import argv
from socket import *
from jimServices import *
from config import *
from log.server_log_config import *
import inspect
from log.logDecor import *
import select

# функция формирования ответа
@logServerDecor
def presence_response(presence_message):
    """
    Формирование ответа клиенту о принятии подключения
    :param presence_message: Словарь presence запроса
    :return: Словарь ответа
    """
    # Делаем проверки
    if ACTION in presence_message and \
                    presence_message[ACTION] == PRESENCE and \
                    TIME in presence_message and \
            isinstance(presence_message[TIME], float):
        # Если всё хорошо шлем ОК
        return {RESPONSE: OK}
    else:
        # Шлем код ошибки
        return {RESPONSE: WRONG_REQUEST, ERROR: "Неверный запрос"}

def create_response(recive_message):
    """
    Формирование ответа клиенту о принятии сообщения
    :param presence_message: Словарь presence запроса
    :return: Словарь ответа
    """
    if ACTION in recive_message and \
                    recive_message[ACTION] == MSG and \
                    TIME in recive_message and \
            isinstance(recive_message[TIME], float) and\
                    MSG in recive_message and \
            isinstance(recive_message[MSG], str):
        return {RESPONSE: ACCEPTED}
    else:
        # Шлем код ошибки
        return {RESPONSE: WRONG_REQUEST, ERROR: "Неверное сообщение"}



if __name__=="__main__":

    arg=getopts(argv)
    
    
    sock=socket(AF_INET,SOCK_STREAM)
    
    sock.bind((arg["a"],arg["p"]))
    sock.listen(5)
    sock.settimeout(0.2)
    logServer.info("Запустили сервер")
    print(f"Запущен сервер с входящими парметрами: {arg}")

    #Список подлюченных клиентов    
    clients=[]
    #Словарь клиентов и их имен
    clientsName={}
    #Словарь служебных сообщений с кодами ответов
    answer={}
    #Словарь принятых сообщений от клиентов
    message={}
    #Словарь сформированных сообщений для отправки
    msg={}
    
    
    while True:
        
        try:     
            conn, addr = sock.accept()  
            clients.append(conn) #Добавляем в список подключенных клиентов
        except OSError as e: #Никто не подключился
            pass
        else: #Если код отработал без ошибок
            logServer.info(f"Соединение от клиента {conn} по адресу {addr}")
            print (f"К серверу подключен новый клиент: {conn}" )
        finally:
            #Обнуляем список клентов ожидающих чтения сообщения сервером, передачи данных от сервера, возаращающих ошибку
            rs=[]
            ws=[]
            es=[]
            try:
                rs, ws, es = select.select(clients, clients, clients, 1)
            except: #Если нет клиентов на чтение и запись
                pass
            
            #Обходим всех клиентов в очереди на чтение
            for r in rs:
                try:
                    message[r] = getMessage(r)
                except: #Если возникает ошибка чтения- это значит, что клиент отключился. 
                    print (f"От сервера отключился клиент: {r}")
                    logServer.info(f"Клиент отключился {r}")
                    clients.remove(r) 
                    
                    for i in clientsName.keys():
                        if clientsName[i]==r:             
                            clientsName.pop(i)
                            break
                if message:

                    #Если это приветственное сообщение - формируем сообьщение о принятии подключения
                    if message[r][ACTION]==PRESENCE:                         
                        answer[r]=presence_response(message[r])

                    #Если это текствое сообщение - посылаем соощбение о его принятии и формируем сообщение с текстом на всех
                    elif message[r][ACTION]==MSG:
                        #Формируем два ответа: подтверждение о принятии сообщения и само сообщение
                        #answer[r]=create_response(message[r])
                        msg[r]=createMessage(message[r][MSG], message[r][USER][ACCOUNT_NAME], message[r][TO])
                        
                    logServer.info(f"Получено сообщение от клиента {message[r][USER][ACCOUNT_NAME]} типа {message[r][ACTION]}")
                    print (f"Получено сообщение от клиента {message[r][USER][ACCOUNT_NAME]} - {message}")
                    
            #Обходим всех клиентов в очереди на чтение данных
            for w in ws:
                try:
                    if message[w][ACTION]==PRESENCE:
                        sendMessage(w, answer[w])
                        logServer.info(f"Клиенту {message[w][USER][ACCOUNT_NAME]} отправлено сообщение {answer[w]}")        

                        #Если мы ответили, что соединение не принято, то удаляем клиента из списка подключенных, иначе запоминаем его имя
                        if answer[w][RESPONSE]!=OK:
                            clients.remove(w)
                        else:
                            clientsName[message[w][USER][ACCOUNT_NAME]]=w

                    elif message[w][ACTION]==MSG:
                       
                        toClient=message[w][TO]
                        if clientsName.get(toClient):
                            sendMessage(clientsName[toClient], msg[w])
                            logServer.info(f"Клиенту {msg[w][TO]} отправлено сообщение {message[w][MSG]}")                    
                            print (f"клиенту {msg[w][TO]} отправлено сообщение {message[w]}")
                        else:
                            sendMessage(w, createMessage("Указанный клиент не подключен", SERVER, message[w][USER][ACCOUNT_NAME]))
                            logServer.info(f"Клиент {toClient} неверно указал получателя сообщения.")                    
                            print (f"Клиент {toClient} неверно указал получателя сообщения.")   
                    
                    message.pop(w)
                    answer.pop(w)
                    msg.pop(w)
                except:
                    pass
