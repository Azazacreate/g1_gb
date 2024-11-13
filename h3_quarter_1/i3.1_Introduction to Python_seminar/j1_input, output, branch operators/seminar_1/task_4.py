# way_1
year = 2024
if year % 4 == 0 and year % 100 != 0 or year % 400 == 0:
	print("YES")
else:
	print("NO")


# way_2
print("YES" if year % 4 == 0 and year % 100 != 0 or year % 400 == 0 else "NO")