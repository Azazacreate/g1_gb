from common.settings import RESPONSE, ERROR, TIME, USER, NAME, ACTION, PRESENCE
from server import send_message_client

response_code_400 = {
    RESPONSE: 400,
    ERROR: 'Bad Request'
}
response_code_200 = {RESPONSE: 200}


def test_no_action():
    assert send_message_client({TIME: '1.1', USER: {NAME: 'Guest'}}) == response_code_400


def test_wrong_action():
    assert send_message_client({ACTION: 'Wrong', TIME: '1.1', USER: {NAME: 'Guest'}}) == response_code_400


def test_no_time():
    assert send_message_client({ACTION: PRESENCE, USER: {NAME: 'Guest'}}) == response_code_400


def test_no_user():
    assert send_message_client({ACTION: PRESENCE, TIME: '1.1'}) == response_code_400


def test_unknown_user():
    assert send_message_client({ACTION: PRESENCE, TIME: 1.1, USER: {NAME: 'Guest1'}}) == response_code_400


def test_ok_check():
    assert send_message_client({ACTION: PRESENCE, TIME: 1.1, USER: {NAME: 'Guest'}}) == response_code_200
