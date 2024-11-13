# program 6

speed_friendFirst = 1
speed_friendSecond = 2
speed_dog = 5
distance = 10000
count = 0
friend = 2

while distance > 7:
    if friend == 1:
        time = distance / (speed_friendFirst + speed_dog)
        friend = 2
    else:
        time = distance / (speed_friendSecond + speed_dog)
        friend = 1
    distance = distance - (speed_friendFirst + speed_friendSecond) * time
    count = count + 1
print('count =', count)
