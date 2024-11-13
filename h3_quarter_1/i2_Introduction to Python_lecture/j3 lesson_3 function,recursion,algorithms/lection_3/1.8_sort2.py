def sort_merge(nums):
    if len(nums) > 1:
        mid = len(nums) // 2
        list_left = nums[:mid]
        list_right = nums[mid:]
        sort_merge(list_left)      # тут будет рекурсия.
        sort_merge(list_right)

        # теперь соединим:воедино все-элементы
        i = j = k = 0
        while i < len(list_left) and j < len(list_right):
            if list_left[i] < list_right[j]:
                nums[k] = list_left[i]
                i += 1
            else:
                nums[k] = list_right[j]
                j += 1
            k += 1
            # чтобы новое значение при-каждой-итерации
        while i < len(list_left):
            nums[k] = list_left[i]
            i += 1
            k += 1
        while j < len(list_right):
            nums[k] = list_right[j]
            j += 1
            k += 1
list_1 = [248, 1, 2, 0, 7, 5, 4, 2, 55, 3]
sort_merge(list_1)
print(list_1)