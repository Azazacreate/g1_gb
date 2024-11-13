import matplotlib.pyplot as plt
from math import factorial

def combinatorics(n, k):
    return int(factorial(n) / (factorial(k) * factorial(n - k))) 

### Создание области отрисовки
fig = plt.figure()
ax = fig.add_axes([0,0,1,1])
ax.set_axis_off()

formula = 'Задача 1. \n'
formula += 'Из колоды в 52 карты извлекаются случайным образом 4 карты. \n'
formula += 'a) Найти вероятность того, что все 4 карты – крести. \n'
formula += 'Необходиом использовать формулу сочетания комбинаторики \n'
formula += '$\\ C^k_n = \\frac{n!}{k!\\left(n-k\\right)!}  $\n'
formula += 'и классическую формулу вероятности. \n'
formula += '$\\ P(A) = \\frac{m}{n} $\n'
formula += 'где m число благоприятных исходов извлечь 4 карты одной масти \n'
formula += 'в колоде 52 карты и 4 масти, соответственно 52/4=13 карт одной масти \n'
formula += '$\\ m : \\ C^k_n = С^{4}_{13} $ \n'
formula += 'а n количество способов извлечь 4 карты из 52 карт. \n'
formula += '$\\ n : \\ C^k_n = С^{4}_{52} $\n'
formula += '\n'

# Вычислим  m
m = combinatorics(13, 4)
formula += 'Вычислим  m:\n'
formula += 'm=' + str(m) + '\n'

# Вычислим  n
n = combinatorics(52, 4)
formula += 'Вычислим  n:\n'
formula += 'n=' + str(n) + '\n'

# Вычислим  P
P = m / n
formula += 'Вычислим  P:\n'
formula += 'P=' + str(round(P,4)) + '\n'

# Ответ
result = P * 100
formula += 'Вероятность того, что все 4 карты – крести:\n'
formula += 'P=' + str(round(result,2)) + '%'

### Отрисовка формулы
t = ax.text(0.5, 0.5, formula,
        horizontalalignment='center',
        verticalalignment='center',
        fontsize=20, color='black')
  
### Определение размеров формулы
ax.figure.canvas.draw()
bbox = t.get_window_extent()
bbox.width, bbox.height

# Установка размеров области отрисовки dpi=80
fig.set_size_inches(bbox.width/80,bbox.height/80)

### Отрисовка или сохранение формулы в файл
plt.show()