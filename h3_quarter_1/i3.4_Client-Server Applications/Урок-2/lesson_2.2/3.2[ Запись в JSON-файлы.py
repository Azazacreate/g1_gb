import json

dict_to_json = {
    "action": "msg",
    "to": "account_name",
    "from": "account_name",
    "encoding": "ascii",
    "message": "message"
    }

with open('mes_example_write.json', 'w') as f_n:
    f_n.write(json.dumps(dict_to_json))

with open('mes_example_write.json') as f_n:
    print(f_n.read())
