def sort_merge(nums):
    if len(nums) > 1:
        mid = len(nums) // 2
        list_left = nums[:mid]
        list_right = nums[mid:]
        sort_merge(list_left)
        sort_merge(list_right)

        i = j = k = 0
        while i < len(list_left) and j < len(list_right):
            if list_left[i] < list_right[j]:
                nums[k] = list_left[i]
                i += 1
            else:
                nums[k] = list_right[j]
                j += 1
            k += 1
        while i < len(list_left):
            nums[k] = list_left[i]
            i += 1
            k += 1
        while j < len(list_right):
            nums[k] = list_right[j]
            j += 1
            k += 1
nums = [38, 27, 43, 3, 9, 82, 10]
sort_merge(nums)
print(nums)