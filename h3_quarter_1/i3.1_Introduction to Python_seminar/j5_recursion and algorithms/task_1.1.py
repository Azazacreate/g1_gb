a_1 = 7
# a_2 = 21
fibo_past, fibo_present = 0, 1
for i in range(0, a_1):
	fibo_past, fibo_present = fibo_present, fibo_present + fibo_past
print(fibo_present)


# закон_1, закон_2
def fibo_1(a_1=7, fibo_past=0, fibo_present=1):
	return fibo_1(a_1-1, fibo_present, fibo_present + fibo_past)


# закон_3	базовый случай
def fibo_1(a_1=7, fibo_past=0, fibo_present=1):
	if a_1 == 0:
		return fibo_present
	return fibo_1(a_1-1, fibo_present, fibo_present + fibo_past)
print(fibo_1(9))
