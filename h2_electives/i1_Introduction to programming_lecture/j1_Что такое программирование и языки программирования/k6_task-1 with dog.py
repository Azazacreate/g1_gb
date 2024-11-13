# task-1 (метр / сек)
speed_manFirst = 1
speed_manSecond = 2
speed_dog = 5
distance = 10000
count_lines = 0
target = "man_2"


while distance > 7:
    if target == "man_2":
        time = distance / (speed_dog + speed_manSecond) # 40 / 5+2
        target = "man_1"
    else:
        time = distance / (speed_dog + speed_manFirst)  # 40 / 5+1
        target = "man_2"
    count_lines += 1
    distance -= (speed_manFirst + speed_manSecond) * time
print(count_lines)