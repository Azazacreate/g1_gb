
import requests

data = {'key1': 'value1'}
resp = requests.get("https://github.com/requests/get", params=data)

resp = requests.get("https://github.com/requests/")
# print(resp.text)

resp = requests.get("https://github.com/requests/")
print(resp.status_code)
print(resp.headers)
