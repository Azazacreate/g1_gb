
import unittest

import server
from config import *


# Модульные тесты
class Test_presence_response(unittest.TestCase):
    def setUp(self):
        # Выполнить настройку тестов (если необходимо)
        pass
    def tearDown(self):
        # Выполнить завершающие действия (если необходимо)
        pass
    def test_OK_presence_response(self):
        # Проверка корректности запроса
        send = {ACTION: PRESENCE, TIME: 1559456348.819856, USER: {ACCOUNT_NAME: 'Alex'}}
        test = server.presence_response(send)
        print ("Первый тест", test)
        self.assertEqual(test,{'response': 200})
    def test_NotOk_presence_response(self):
        # Проверка не верности запроса
        test = server.presence_response("a")
        print ("Второй тест", test)
        self.assertEqual(test,{'response': 400, 'error': 'Неверный запрос'})      

# Запустить тестирование
if __name__ == '__main__':
    unittest.main()
