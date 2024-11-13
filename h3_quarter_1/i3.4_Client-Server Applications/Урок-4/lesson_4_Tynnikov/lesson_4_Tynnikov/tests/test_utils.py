import unittest
from unittest.mock import Mock

from common import utils as u


class TestUtils(unittest.TestCase):

    def setUp(self) -> None:
        self.socket = Mock()

    def test_get_message_raise_error_bytes(self):
        self.socket.recv.return_value = {"bytes": "no"}
        with self.assertRaises(ValueError):
            u.get_message(self.socket)

    def test_get_message_raise_error_dict(self):
        self.socket.recv.return_value = b'1'
        with self.assertRaises(ValueError):
            u.get_message(self.socket)

    def test_get_message_correct_data(self):
        self.socket.recv.return_value = b'{"bytes": "yes"}'
        gm = u.get_message(self.socket)
        self.assertEqual(gm, {"bytes": "yes"})

    def test_send_message_correct_data(self):
        u.send_message(self.socket, {"type": "message", "body": "huray"})
        self.socket.send.assert_called_once_with(b'{"type": "message", "body": "huray"}')
