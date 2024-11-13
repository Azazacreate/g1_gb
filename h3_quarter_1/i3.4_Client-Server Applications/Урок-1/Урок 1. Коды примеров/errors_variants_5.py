"""Модуль errors_variants"""

# ошибка - преобразование кириллицы в байты


# ошибка - разные кодировки для преобразований
ERR_STR = 'Testování'
ERR_STR_BYTES = ERR_STR.encode('utf-16')
ERR_STR = ERR_STR_BYTES.decode('utf-8')
print(ERR_STR)
