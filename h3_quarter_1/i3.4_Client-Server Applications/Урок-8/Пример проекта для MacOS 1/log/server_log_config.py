
import logging
import logging.handlers
import os

logServer=logging.getLogger('Server')

path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "server.log")

out=logging.handlers.TimedRotatingFileHandler(path, when="D")

format = logging.Formatter("%(asctime)s %(levelname)-10s %(module)-10s %(message)s")
out.setFormatter(format)

logServer.addHandler(out)
logServer.setLevel(logging.INFO)

