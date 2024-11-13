import json
import pytest
from common.settings import ENCODING, ACTION, PRESENCE, TIME, USER, NAME, RESPONSE, ERROR
from common.utils import send_json_string, get_dict_message


class TestSocket:
    def __init__(self, dict_message):
        self.dict_message = dict_message
        self.json_encode = None
        self.send_message = None

    def send(self, message):
        json_message_dumps = json.dumps(self.dict_message)
        self.json_encode = json_message_dumps.encode(ENCODING)
        self.send_message = message

    def recv(self, max_len):
        json_test_message = json.dumps(self.dict_message)
        return json_test_message.encode(ENCODING)


class TestUtilsGetSend:
    dict_message = {
        ACTION: PRESENCE,
        TIME: 111111.111111,
        USER: {
            NAME: 'test_test'
        }
    }
    response_code_200 = {RESPONSE: 200}
    response_code_400 = {
        RESPONSE: 400,
        ERROR: 'Bad Request'
    }

    def test_utils_send_message(self):
        socket = TestSocket(self.dict_message)
        send_json_string(socket, self.dict_message)
        assert socket.json_encode == socket.send_message
        with pytest.raises(Exception):
            send_json_string(socket, socket)

    def test_utils_get_message(self):
        response_ok = TestSocket(self.response_code_200)
        response_error = TestSocket(self.response_code_400)
        assert get_dict_message(response_ok) == self.response_code_200
        assert get_dict_message(response_error) == self.response_code_400