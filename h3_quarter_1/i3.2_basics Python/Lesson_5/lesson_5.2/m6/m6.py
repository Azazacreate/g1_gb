res = 0
with open("m6.txt", "r") as a1:
    for line in a1:
        a2 = line.split(", ")
        for words in a2[1:]:
            if words != "-" and "0":
                res += int(words)
        print(res)
        res = 0