import os
import requests
import json
from pprint import pprint
from dotenv import load_dotenv


dotenv_path = os.path.join(os.path.dirname(__file__), '.env')
if os.path.exists(dotenv_path):
    load_dotenv(dotenv_path)

url = "https://api.giphy.com/v1/gifs/search"
param = {
    "api_key": os.getenv('api_key'),
    "q": "programming",
    'limit': 5,
    'offset': 0,
    'rating': 'g',
    'lang': 'en',
    'bundle': 'messaging_non_clips',
}
headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36',
           'Accept': '*/*',
}


responce = requests.get(url, params=param, headers=headers)
j_data = responce.json()
with open('k6_gifs.json', 'w') as f:
    json.dump(j_data, f)
for gif in j_data.get('data'): print(gif.get('images').get('original').get('url'))
pprint(j_data)