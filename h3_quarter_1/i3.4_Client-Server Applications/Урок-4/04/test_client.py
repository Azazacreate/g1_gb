import sys

import unittest
import client
import warnings

# warnings.simplefilter("ignore", ResourceWarning)
#
# def ignore_warnings(test_func):
#     def do_test(self, *args, **kwargs):
#         with warnings.catch_warnings():
#             warnings.simplefilter("ignore", ResourceWarning)
#             test_func(self, *args, **kwargs)
#     return do_test

class TestChat(unittest.TestCase):
    def setUp(self):
        self.s = client.get_server_socket('localhost', 17777)
        self.c = client.get_client_socket('localhost', 17777)
        self.sender = self.s.accept()[0]

        client.send_data(self.c, {'test': 'test'})

    def tearDown(self):
        self.c.close()
        self.s.close()

    def test_get_data(self):
        self.assertEqual(client.get_data(self.sender), {'test': 'test'})

    def test_send_data(self):
        with self.assertRaises(TypeError):
            client.send_data()

    def close(self):
        self.session.close()


if __name__ == '__main__':
    unittest.main()