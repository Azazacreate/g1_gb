import matplotlib.pyplot as plt
from math import factorial, exp

def poisson(m,p,n):
    lamb=p*n
    return (lamb**m)/factorial(m)*exp(-lamb)

### Создание области отрисовки
fig = plt.figure()
ax = fig.add_axes([0,0,1,1])
ax.set_axis_off()

formula = 'Задача 2. \n'
formula += 'Вероятность того, что лампочка перегорит в течение первого дня эксплуатации, равна 0.0004. \n'
formula += 'В жилом комплексе после ремонта в один день включили 5000 новых лампочек. \n'
formula += 'a) Какова вероятность, что ни одна из них не перегорит в первый день? \n'
formula += 'Так как проводится большое количество испытаний и при том вероятность события мала \n'
formula += 'Необходиом использовать формулу Пуассона:  \n'
formula += '$\\ P_m = \\frac{\\Lambda^m}{m!}e^{-\\Lambda}  $\n'
formula += 'Среднее количество наступления событий за определенную еденицу измерений \n'
formula += '$\\ \\Lambda = p*n  $\n'
formula += 'Число наступления события, равна перегоранию лампочек, соответственно p=0.0004.  \n'
formula += 'Количество испытаний, равна количеству включенных лампочек, соответственно n=5000. \n'
formula += 'Вероятность наступления событий, равна вероятности перегорания 0 лампочек, соответственно m=0. \n'
formula += '\n'

# Вычислим  P
P = poisson(0,0.0004,5000)
formula += 'Вычислим  P:\n'
formula += 'P=' + str(round(P,4)) + '\n'

# Ответ
formula += 'Вероятность, что ни одна из них не перегорит в первый день:\n'
formula += 'P=' + str(round(P,4)) + '%'

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