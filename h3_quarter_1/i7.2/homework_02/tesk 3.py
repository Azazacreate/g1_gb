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

formula = 'Задача 3. \n'
formula += 'Монету подбросили 144 раза. \n'
formula += 'Какова вероятность, что орел выпадет ровно 70 раз? \n'
formula += 'Необходиом использовать формулу Бернулли \n'
formula += '$\\ P_n(X=k) = C^k_np^kq^{n-k}  $\n'
formula += 'Формулу сочетания комбинаторики \n'
formula += '$\\ C^k_n = \\frac{n!}{k!\\left(n-k\\right)!}  $\n'

formula += 'Число наступления события, равна количеству выпадения орла на монете, соответственно k=70.  \n'
formula += 'Количество испытаний, равна количеству подброшенных монет, соответственно n=144. \n'
formula += 'Вероятность наступления событий, равна вероятности выпадения орла, соответственно p=0.5. \n'
formula += 'а q противоположная вероятность. \n'
formula += '$\\ q = 1 - p = 0.5 $\n'
formula += '\n'

# Вычислим  P
P = bernulli(144, 70, 0.5)
formula += 'Вычислим  P:\n'
formula += 'P=' + str(round(P,4)) + '\n'

# Ответ
result = P * 100
formula += 'Вероятность того, что если подбросить 144 раза монетку, орел выпадет ровно 70 раз:\n'
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