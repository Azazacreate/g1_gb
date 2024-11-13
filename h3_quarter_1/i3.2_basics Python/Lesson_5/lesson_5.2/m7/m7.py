import json

a4 = []
lines = 0
dict_1 = {}
with open("m7.txt", "r") as a1:
    for line in range(1):
        a1.readline()
    for line in a1:
        a2 = line.split(", ")
        a3 = int(a2[2]) - int(a2[3])
        # print(a2[0], " = ", a3)
        dict_1[a2[0]] = a3
        if a3 > 0:
            a4.append(a3)
            lines += 1
    dict_2 = {"profit_average": sum(a4) / lines}
    # print("Средняя прибыль: ", sum(a4) / lines)
    list_1 = [dict_1, dict_2]
print(list_1)
with open("m7.json", "w") as json_1:
    json.dump(list_1, json_1)
