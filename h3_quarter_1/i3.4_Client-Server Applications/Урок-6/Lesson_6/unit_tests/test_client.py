"""Unit-тесты клиента"""


import sys
import os
import unittest
sys.path.append(os.path.join(os.getcwd(), '..'))
#from client_v2 import create_presence, process_ans, Client
from client_v2 import Client
from common.variables import RESPONSE, ERROR, USER, ACCOUNT_NAME, TIME, ACTION, PRESENCE, \
    CURRENT_TIME

class TestClass(unittest.TestCase):
    '''
    Класс с тестами
    '''

    create_new_client_from_class = Client()

    def test_def_presense(self):
        """Тест коректного запроса"""
        test = self.create_new_client_from_class.create_presence()
        test[TIME] = 1.1  # время необходимо приравнять принудительно
        # иначе тест никогда не будет пройден
        self.assertEqual(
            test, {
                ACTION: PRESENCE, TIME: 1.1, USER: {
                    ACCOUNT_NAME: 'Guest'}})

    '''
        def test_def_presense2(self):
            """Тест коректного запроса"""
            test = self.create_new_client_from_class.create_presence()
            test_time = CURRENT_TIME
            test[TIME] = test_time  # а теперь добавим текущее время
                              # результат удивит
            self.assertEqual(test, {ACTION: PRESENCE, TIME: test_time, USER: {ACCOUNT_NAME: 'Guest'}})
    '''

    def test_200_ans(self):
        """Тест корректтного разбора ответа 200"""
        self.assertEqual(self.create_new_client_from_class.process_ans(
            {RESPONSE: 200}), '200 : OK')

    def test_400_ans(self):
        """Тест корректного разбора 400"""
        self.assertEqual(self.create_new_client_from_class.process_ans(
            {RESPONSE: 400, ERROR: 'Bad Request'}), '400 : Bad Request')

    def test_no_response(self):
        """Тест исключения без поля RESPONSE"""
        self.assertRaises(
            ValueError, self.create_new_client_from_class.process_ans, {
                ERROR: 'Bad Request'})


if __name__ == '__main__':
    unittest.main()
