arr = [5, 8, 6, 4, 9, 2, 7, 3]      #19
sum_max = 0
i = 0
while i < len(arr):
    sum_current = arr[i-2] + arr[i-1] + arr[i]
    i += 1
    if sum_current > sum_max:
        sum_max =  sum_current
print(sum_max)