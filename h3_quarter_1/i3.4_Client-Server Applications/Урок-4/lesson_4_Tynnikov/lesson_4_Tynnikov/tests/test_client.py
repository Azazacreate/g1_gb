import sys
import unittest
from unittest.mock import patch

import client as c
from common.variables import TIME, DEFAULT_PORT, DEFAULT_IP_ADDRESS


class TestClient(unittest.TestCase):

    def test_create_presence(self):
        cp = c.create_presence()
        cp[TIME] = '1'
        self.assertEqual(cp, {'action': 'presence', 'time': '1', 'user': {'account_name': 'Guest'}})

    def test_create_presence_with_wrong_time(self):
        cp = c.create_presence()
        self.assertNotEqual(cp, {'action': 'presence', 'time': '1', 'user': {'account_name': 'Guest'}})

    def test_process_ans_with_response_200(self):
        pa = c.process_ans({"response": 200})
        self.assertEqual(pa, "200 : OK")

    def test_process_ans_with_response_400(self):
        pa = c.process_ans({"response": 400})
        self.assertEqual(pa, "400 : error")

    def test_process_without_response(self):
        with self.assertRaises(ValueError):
            c.process_ans('other_value')

    def test_get_client_address_and_port(self):
        test_args = ["client.py", "192.168.0.113", "8079"]
        with patch.object(sys, 'argv', test_args):
            gcaap = c.get_client_address_and_port()
            assert gcaap == ('192.168.0.113', 8079)

    def test_get_client_address_and_port_with_system_port(self):
        test_args = ["client.py", "192.168.0.113", "80"]
        with patch.object(sys, 'argv', test_args):
            with self.assertRaises(SystemExit):
                c.get_client_address_and_port()

    def test_get_client_address_and_port_without_value(self):
        test_args = ["client.py"]
        with patch.object(sys, 'argv', test_args):
            gcaap = c.get_client_address_and_port()
            assert gcaap == (DEFAULT_IP_ADDRESS, DEFAULT_PORT)
