"""Модуль modules"""

import subprocess
import chardet
import os

ARGS = ['ping', 'yandex.ru']
YA_PING = subprocess.Popen(ARGS, stdout=subprocess.PIPE)
print(YA_PING.stdout)
for line in YA_PING.stdout:
    res = chardet.detect(line)
    print(line.decode(encoding=res['encoding']))



#print(os.name)
