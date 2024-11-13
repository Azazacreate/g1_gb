from logging import getLogger, StreamHandler, Formatter, INFO
from sys import stdout

logger = getLogger("app.main") # регистратор верхнего уровня
handler = StreamHandler(stdout) # обработчик логгирования
format = Formatter("%(levelname)-10s %(asctime)-30s %(message)s") # формат записи в лог-файле

handler.setFormatter(format)
logger.addHandler(handler)

logger.setLevel(INFO)


logger.info("Это отладка")