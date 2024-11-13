import json
from common.settings import DEFAULT_RECV, ENCODING


def send_json_string(socket, message):
    """
    Функция принимает на вход сокет и словарь
    """
    json_message_dumps = json.dumps(message)  # переводим словарь в json строку
    json_encode = json_message_dumps.encode(ENCODING)  # encode кодирует json стоку в байты
    socket.send(json_encode)  # отправлем байты в сокет


def get_dict_message(socket_bytes):
    """
    Функция принимает на вход байты и возвращает словарь
    """
    get_response = socket_bytes.recv(DEFAULT_RECV)  # определение размера пакета в байтах

    if isinstance(get_response, bytes):  # проверяем получили ли мы тип bytes для переменной get_response
        get_json_response = get_response.decode(ENCODING)  # получаем json строку из полученных байтов функцией decode
        get_dict_response = json.loads(get_json_response)  # получаем словарь используя функцию loads
        if isinstance(get_dict_response, dict):  # проверяем что get_dict_response имеет тип dict
            return get_dict_response  # возвращаем словарь
        raise ValueError  # возбуждаем указанное исключение
    raise ValueError  # возбуждаем указанное исключение
