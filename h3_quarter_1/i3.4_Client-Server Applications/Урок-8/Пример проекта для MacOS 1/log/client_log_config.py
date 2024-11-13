
import logging
import os

logClient=logging.getLogger('Client')

format = logging.Formatter("%(asctime)s %(levelname)-10s %(module)-10s %(message)s")


path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "client.log")
out=logging.FileHandler(path,encoding="utf-8")
out.setFormatter(format)
logClient.addHandler(out)

logClient.setLevel(logging.INFO)

