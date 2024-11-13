import base64
import pickle

message = base64.b64decode()
print(type(message))
xbytes = pickle.dumps(message)
print(type(xbytes))
dict_obj = pickle.loads(xbytes)
print(type(dict_obj))


with open('decoded4.bin', 'wb') as pick:
    pickle.dump(dict_obj, pick)
