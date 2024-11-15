import sys

import unittest
import socket
import client


class TestServer(unittest.TestCase):
    def setUp(self):
        self.s = client.get_server_socket('localhost', 17777)

    def tearDown(self):
        self.s.close()

    def test_server_socket_is_socket(self):
        self.assertIsInstance(self.s, socket.socket)

    def test_server_socket_addr(self):
        self.assertEqual(self.s.getsockname(), ('127.0.0.1', 17777))


if __name__ == '__main__':
    unittest.main()