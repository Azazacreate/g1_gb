"""
5. Выполнить пинг веб-ресурсов yandex.ru, youtube.com и
преобразовать результаты из байтовового в строковый тип на кириллице.
"""

from subprocess import Popen, PIPE
from chardet import detect

ARGS = ['ping', 'yandex.ru']
YA_PING = Popen(ARGS, stdout=PIPE)
for line in YA_PING.stdout:
    result = detect(line)
    print(result)
    line = line.decode(result['encoding']).encode('utf-8')
    print(line.decode('utf-8'))
