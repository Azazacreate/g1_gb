#task_1
# import numpy as np
# np.random.seed(1)
# n = 600
# b = np.random.randint(1, 7, n)
# a = b[b==3]
# m = len(a)
# W = m/n
# print(m)
# print(W)


#task_2
import numpy as np
np.random.seed(1)
n = 360
c = np.random.randint(1, 7, n)
d = np.random.randint(1, 7, n)
a = c[(c == 1) & (d == 2)]
m = len(a)
W = m/n
print(m, W)