import matplotlib.pyplot as plt
from math import factorial

def combinatorics(n, k):
    return int(factorial(n) / (factorial(k) * factorial(n - k))) 

### Создание области отрисовки
fig = plt.figure()
ax = fig.add_axes([0,0,1,1])
ax.set_axis_off()

formula = 'Задача 4. \n'
formula += 'В первом ящике находится 10 мячей, из которых 7 - белые. Во втором ящике - 11 мячей, из которых 9 белых. \n'
formula += 'Из каждого ящика вытаскивают случайным образом по два мяча. Какова вероятность того, что: б) ровно два мяча белые? \n'
formula += 'Необходиом использовать формулу сочетания комбинаторики \n'
formula += '$\\ C^k_n = \\frac{n!}{k!\\left(n-k\\right)!}  $\n'
formula += 'и классическую формулу вероятности. \n'
formula += '$\\ P(A) = \\frac{m_1}{n_1} \\ {,} \\ P(B) = \\frac{m_2}{n_2} \\ {,} $'
formula += '$\\ P(C) = \\frac{m_3}{n_3} \\ {,} \\ P(D) = \\frac{m_4}{n_4} \\ {,} $'
formula += '$\\ P(E) = \\frac{m_5}{n_5} \\ {,} \\ P(F) = \\frac{m_6}{n_6} $\n'
formula += '$\\ {Событие_А:} \\ {m_1} $'
formula += ' из первой корзины извлекли 2 белых шара '
formula += '$\\ {m_1} : \\ C^k_n = С^{2}_{7} \\ {И} $ \n'
formula += '$\\ {Событие_B:} \\ {m_2} $'
formula += ' второй корзины извлекли 2 не белых шара '
formula += '$\\ {m_2} : \\ C^k_n = С^{2}_{2} \\ {ИЛИ} $ \n'
formula += '$\\ {Событие_C:} \\ {m_3} $'
formula += ' из первой корзины извлекли 1 белый и 1 не белый шар '
formula += '$\\ {m_3} : \\ C^k_n = С^{1}_{7}*С^{1}_{3} \\ {И} $ \n'
formula += '$\\ {Событие_D:} \\ {m_4} $'
formula += ' из второй корзины извлекли 1 белый и 1 не белый шар '
formula += '$\\ {m_4} : \\ C^k_n = С^{1}_{9}*С^{1}_{2} \\ {ИЛИ} $ \n'
formula += '$\\ {Событие_E:} \\ {m_5} $'
formula += ' из первой корзины извлекли 2 не белых шара '
formula += '$\\ {m_5} : \\ C^k_n = С^{2}_{3} \\ {И} $ \n'
formula += '$\\ {Событие_F:} \\ {m_6} $'
formula += ' из второй корзины извлекли 2 белых шара '
formula += '$\\ {m_6} : \\ C^k_n = С^{2}_{9} $ \n'
formula += '$\\ {n_1} $'
formula += ' количество извлечения из первого ящика 2-х мячей из 10. \n'
formula += '$\\ {n_1} : \\ C^k_n = С^{2}_{10} $\n'
formula += '$\\ {n_2} $'
formula += ' количество извлечения из второго ящика 2-х мячей из 11. \n'
formula += '$\\ {n_2} : \\ C^k_n = С^{2}_{11} $\n'
formula += ' Вероятность одновременного наступления события вычисляется, как: \n'
formula += '$\\ {P=P(A)*P(B)+P(C)*P(D)+P(E)*P(F)} $\n'

# Вычислим  m1, m2, m3, m4, m5, m6
m1 = combinatorics(7, 2)
m2 = combinatorics(2, 2)
m3 = combinatorics(7, 1) * combinatorics(3, 1)
m4 = combinatorics(9, 1) * combinatorics(2, 1)
m5 = combinatorics(3, 2)
m6 = combinatorics(9, 2)
formula += 'Вычислим  $\\ {m_1} \\ , \\ {m_2} \\ , \\ {m_3} \\ , \\ {m_4} \\ , \\ {m_5} \\ , \\ {m_6} $ \n'
formula += '$\\ {m_1}=' + str(m1) + ' \\ и \\ {m_2}=' + str(m2) + ' \\ и \\ {m_3}=' + str(m3) + ' \\ и \\ {m_4}=' + str(m4) + ' \\ и \\ {m_5}=' + str(m5) + ' \\ и \\ {m_6}=' + str(m6) + ' $ \n'

# Вычислим  n1 и n2
n1 = combinatorics(10, 2)
n2 = combinatorics(11, 2)
formula += 'Вычислим  $\\ {n_1} \\ и \\ {n_2} $ \n'
formula += '$\\ {n_1}=' + str(n1) + ' \\ и \\ {n_2}=' + str(n2) + ' $ \n'

# Вычислим  P(A) и P(B)
P1 = m1 / n1
P2 = m2 / n2
P3 = m3 / n1
P4 = m4 / n2
P5 = m5 / n1
P6 = m6 / n2
P = P1*P2+P3*P4+P5*P6
formula += 'Вычислим  $\\ {P(A)} \\ , \\ {P(B)} \\ , \\ {P(C)} \\ , \\ {P(D)} \\ , \\ {P(E)} \\ , \\ {P(F)} \\ , \\ {P} $ \n'
formula += '$\\ {P(A)}=' + str(round(P1,4)) + ' \\ , \\ {P(B)}=' + str(round(P2,4)) + ', $'
formula += '$\\ {P(C)}=' + str(round(P1,4)) + ' \\ , \\ {P(D)}=' + str(round(P2,4)) + ', $'
formula += '$\\ {P(E)}=' + str(round(P1,4)) + ' \\ , \\ {P(F)}=' + str(round(P2,4)) + ', $'
formula += '$\\ {P}=' + str(round(P,4)) + ' $ \n'

# Ответ
result = P * 100
formula += 'Вероятность того, что все мячи белые:\n'
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


