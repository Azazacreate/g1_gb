import sys
import unittest
from unittest.mock import patch


from common.variables import ACTION, PRESENCE, TIME, USER, ACCOUNT_NAME, RESPONSE, ERROR
import server as s

class TestServer(unittest.TestCase):
    response_error = {RESPONSE: 400, ERROR: "Bad Request"}
    response_ok = {RESPONSE: 200}

    def test_process_client_server_ok(self):
        pcs = s.process_client_message({ACTION: PRESENCE, TIME: "time", USER: {ACCOUNT_NAME: 'Guest'}})
        self.assertEqual(pcs, self.response_ok)

    def test_process_client_server_without_action(self):
        pcs = s.process_client_message({TIME: "time", USER: {ACCOUNT_NAME: 'Guest'}})
        self.assertEqual(pcs, self.response_error)

    def test_process_client_server_without_time(self):
        pcs = s.process_client_message({ACTION: PRESENCE, USER: {ACCOUNT_NAME: 'Guest'}})
        self.assertEqual(pcs, self.response_error)

    def test_process_client_server_without_account_name(self):
        pcs = s.process_client_message({ACTION: PRESENCE, TIME: "time", USER: {ACCOUNT_NAME: 'Tom'}})
        self.assertEqual(pcs, self.response_error)

    def test_listen_port_correct_value(self):
        test_args = ["server.py", "-p", "8079", "-a", "192.168.0.113"]
        with patch.object(sys, 'argv', test_args):
            glp = s.get_listen_port()
            assert glp == 8079

    def test_listen_port_default_value(self):
        test_args = []
        with patch.object(sys, 'argv', test_args):
            glp = s.get_listen_port()
            assert glp == 7777

    def test_listen_port_80(self):
        test_args = ["server.py", "-p", "80", "-a", "192.168.0.113"]
        with patch.object(sys, 'argv', test_args):
            with self.assertRaises(SystemExit):
                s.get_listen_port()

    def test_get_listen_without_address(self):
        test_args = ["server.py", "-p", "80", "-a"]
        with patch.object(sys, 'argv', test_args):
            with self.assertRaises(SystemExit):
                s.get_listen_address()

    def test_get_listen_address(self):
        test_args = ["server.py", "-p", "80", "-a", "192.168.0.113"]
        with patch.object(sys, "argv", test_args):
            gta = s.get_listen_address()
            assert gta == "192.168.0.113"
