dict_to_json = {
    "action": "msg",
    "to": "account_name",
    "from": "account_name",
    "encoding": "ascii",
    "message": "message"
    }

import json
with open('mes_example_write_3.json', 'w') as f_n:
    json.dump(dict_to_json, f_n, sort_keys=True, indent=2)

with open('mes_example_write_3.json') as f_n:
    print(f_n.read())
