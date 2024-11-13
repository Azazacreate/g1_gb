import json
from .variables import MAX_PACKAGE_LENGTH


def get_message(sock):
    """
    Утилита приема и декорирования сообщения принимает байты выдает словарь,
    если принято что-то другое выдает ошибку значения.
    :param sock:
    :return:
    """

    encoded_response = sock.recv(MAX_PACKAGE_LENGTH)
    if isinstance(encoded_response, bytes):
        json_response = encoded_response.decode('utf-8')
        response = json.loads(json_response)
        if isinstance(response, dict):
            return response
        raise ValueError
    raise ValueError


def send_message(sock, message):
    """
    Утилита кодирования и отправки сообщения. Принимает словарь и отправляет его.
    :param sock:
    :param message:
    :return:
    """

    json_message = json.dumps(message)
    encoded_message = json_message.encode('utf-8')
    sock.send(encoded_message)
