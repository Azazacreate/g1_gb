import matplotlib.pyplot as plt
from math import factorial

def combinatorics(n, k):
    return int(factorial(n) / (factorial(k) * factorial(n - k))) 

def bernulli(n, k, p):
    return combinatorics(n, k)*(p**k)*(1-p)**(n-k)

### Создание области отрисовки
fig = plt.figure()
ax = fig.add_axes([0,0,1,1])
ax.set_axis_off()

formula = 'Задача 1. \n'
formula += 'Вероятность того, что стрелок попадет в мишень, выстрелив один раз, равна 0.8. \n'
formula += 'Стрелок выстрелил 100 раз. \n'
formula += 'Найдите вероятность того, что стрелок попадет в цель ровно 85 раз. \n'
formula += 'Необходиом использовать формулу Бернулли \n'
formula += '$\\ P_n(X=k) = C^k_np^kq^{n-k}  $\n'
formula += 'Формулу сочетания комбинаторики \n'
formula += '$\\ C^k_n = \\frac{n!}{k!\\left(n-k\\right)!}  $\n'
formula += 'Число наступления события, равна количеству попаданий, соответственно k=85.  \n'
formula += 'Количество испытаний, равна количеству выстрелов, соответственно n=100. \n'
formula += 'Вероятность наступления событий, равна вероятности попадания в мишень, соответственно p=0.8. \n'
formula += 'а q противоположная вероятность. \n'
formula += '$\\ q = 1 - p = 0.2 $\n'
formula += '\n'

# Вычислим  P
P = bernulli(100, 85, 0.8)
formula += 'Вычислим  P:\n'
formula += 'P=' + str(round(P,4)) + '\n'

# Ответ
result = P * 100
formula += 'Вероятность того, что стрелок попадет в цель ровно 85 раз:\n'
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