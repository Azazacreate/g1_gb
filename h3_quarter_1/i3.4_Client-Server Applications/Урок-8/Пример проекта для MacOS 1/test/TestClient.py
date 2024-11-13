
import unittest

import client
from config import *
from errors import *
import errors


# Модульные тесты
class Test_createPresence(unittest.TestCase):
    def setUp(self):
        # Выполнить настройку тестов (если необходимо)
        pass
    def tearDown(self):
        # Выполнить завершающие действия (если необходимо)
        pass
    def test_createPresence(self):
        # Корректность создания сообщения серверу
        name="Alex"
        test = client.createPresence(name)
        self.assertEqual([test[ACTION], test[USER]],["presence", {'account_name': name}])
    def test_createPresence_LongName(self):
        # Возбуждение ошибки при слишком длинном имени
        name="123456789012345678901234567"
        self.assertRaises(errors.UsernameToLongError,client.createPresence, name)

# Запустить тестирование
if __name__ == '__main__':
    unittest.main()
