"""Модуль json_read"""

from json import load, loads

# использование метода load для чтения json-файла, как объекта
# преобразуем json-объект в python-объект (словарь)
with open('mes_example_read.json') as f_n:
    OBJ = load(f_n)
    print(OBJ)















for section, commands in OBJ.items():
    print(section)
    print(commands)

# использование метода loads для чтения json-файла, как строки
# преобразуем json-строку в python-объект (словарь)
with open('mes_example_read.json') as f_n:
    F_N_CONTENT = f_n.read()
    OBJ = json.loads(F_N_CONTENT)
    print(type(OBJ))


for section, commands in OBJ.items():
    print(section)
    print(commands)


#dict -> dumps -> encode

#decode -> loads -> dict

#консоль - текст - словарь! - json-стр - байты - сокет
#сокет - байты - стр - dict

# dict - dump - encode?
# dict - js-стр - encode

# dict - dumps = json-строка - bytes -> сокет
# сокет -> bytes - decode - json-строка - loads


# dump(объект потока данных)
# python-объект -> json-объект

# load(объект потока данных)
# json-объект -> python-объект


# dumps(python-объект) -> json-строка
# write(json-строка)

# read() -> json-строка
# loads(json-строка) -> python-объект
