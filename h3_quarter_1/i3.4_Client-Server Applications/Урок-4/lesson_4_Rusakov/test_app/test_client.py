import pytest
from common.settings import TIME, ACTION, USER, NAME, PRESENCE, RESPONSE, ERROR
from client import create_client, give_status_message


def test_def_create_client():
    test = create_client()
    test[TIME] = 1.1
    assert test == {ACTION: PRESENCE, TIME: 1.1, USER: {NAME: 'Guest'}}


def test_200_code():
    """Тест корректтного разбора ответа 200"""
    assert give_status_message({RESPONSE: 200}) == '200 : OK'


def test_400_code():
    """Тест корректного разбора 400"""
    assert give_status_message({RESPONSE: 400, ERROR: 'Bad Request'}) == '400 : Bad Request'


def test_not_response_value():
    """Тест исключения без поля RESPONSE"""
    with pytest.raises(ValueError):
        give_status_message({ERROR: 'Bad Request'})