dict_1 = {
    "One": "Один",
    "Two": "Два",
    "Three": "Три",
    "Four": "Четыре",
}
with open("m4.txt", "r+") as a1:
    for line in a1:
        for el in dict_1.keys():
            line = line.replace(el, dict_1[el])
        print(line)
        with open("m4_out.txt", "a") as a2:
            a2.writelines(line)
