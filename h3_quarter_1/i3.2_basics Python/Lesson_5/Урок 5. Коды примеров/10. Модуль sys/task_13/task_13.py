"""Модуль sys"""

from sys import argv, executable, exit, path, platform

# Параметр argv позволяет получить список аргументов,
# которые связаны со скриптом при его запуске из командной строки.

# Параметр executable позволяет достучаться до полного пути к Python-интерпретатору
print(executable)

# Параметр exit представляет собой функцию, обеспечивающую выход из Python-программы
# exit(0)
# exit(1)

# Функция path() возвращает список строк-путей поиска для модулей
print(path)

# Параметр platform, соответствующий идентификатору платформы
print(platform)

# sys.stdin / stdout / stderr
# Аналоги файловых объектов, соответствуют потокам ввода,
# вывода и ошибок интерпретатора, соответственно.

# stdin — применяется для любого интерактивного ввода (сюда входят и вызовы input()).
# stdout — применяется для вывода операторов print(), а также input()-запросов.
# stderr — собственные запросы интерпретатора и его сообщения об ошибках.
