# json.load(l3).items()
import json
with open("l3.json") as l3:
    for el, el2 in json.load(l3).items():
        print(el, el2)


# json.loads(l3.read()).items()
import json
with open("l3.json") as l3:
    for el, el2 in json.loads(l3.read()).items():
        print(el, el2)
