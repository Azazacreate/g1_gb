import requests
import json
url = 'https://openlibrary.org/api/books.json'
subject = 'Artificial intelligence'
params = {
    'subject': subject,
    'limit': 1,
}
response = requests.get(url, params=params)
if response.status_code < 400:
    print('Successful response! ', response.status_code)
else:
    print('wrong( number of response = ', response.status_code)
data = response.json()
print(response.text)