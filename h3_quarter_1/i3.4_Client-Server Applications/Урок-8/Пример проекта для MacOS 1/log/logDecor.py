
import inspect
from log.server_log_config import *
from log.client_log_config import *


def logServerDecor(func):
    
    def wrapper(*args, **kwargs):
        logServer.info(f"Собщение из декоратора: вызов функции {func.__name__} с аргументами {args, kwargs} из функции {inspect.stack()[0][3]}")
        return func(*args, **kwargs)
    return wrapper  

def logClientDecor(func):
    
    def wrapper(*args, **kwargs):
        logClient.info(f"Собщение из декоратора: вызов функции {func.__name__} с аргументами {args, kwargs} из функции {inspect.stack()[0][3]}")
        return func(*args, **kwargs)
    return wrapper  
