import matplotlib.pyplot as plt
from math import factorial

def combinatorics(n, k):
    return int(factorial(n) / (factorial(k) * factorial(n - k))) 

### Создание области отрисовки
fig = plt.figure()
ax = fig.add_axes([0,0,1,1])
ax.set_axis_off()

formula = 'Задача 2. \n'
formula += 'На входной двери подъезда установлен кодовый замок, содержащий десять кнопок с цифрами от 0 до 9. \n'
formula += 'Код содержит три цифры, которые нужно нажать одновременно. \n'
formula += 'Какова вероятность того, что человек, не знающий код, откроет дверь с первой попытки? \n'
formula += 'Необходиом использовать формулу сочетания комбинаторики \n'
formula += '$\\ C^k_n = \\frac{n!}{k!\\left(n-k\\right)!}  $\n'
formula += 'и классическую формулу вероятности. \n'
formula += '$\\ P(A) = \\frac{m}{n} $\n'
formula += 'Из-за того, что кнопки нажимаются одновременно, порядок не важен  \n'
formula += 'm количество благоприятных исходов равна 1, открытию замка \n'
formula += '$\\ m : \\ {1} $ \n'
formula += 'а n количество сочетаний 3-х кнопок из 10. \n'
formula += '$\\ n : \\ C^k_n = С^{3}_{10} $\n'
formula += '\n'

# Вычислим  m
m = combinatorics(1, 1)
formula += 'Вычислим  m:\n'
formula += 'm=' + str(m) + '\n'

# Вычислим  n
n = combinatorics(10, 3)
formula += 'Вычислим  n:\n'
formula += 'n=' + str(n) + '\n'

# Вычислим  P
P = m / n
formula += 'Вычислим  P:\n'
formula += 'P=' + str(round(P,4)) + '\n'

# Ответ
result = P * 100
formula += 'Вероятность того, что человек, не знающий код, откроет дверь с первой попытки:\n'
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


