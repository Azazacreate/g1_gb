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
formula += 'Из каждого ящика вытаскивают случайным образом по два мяча. Какова вероятность того, что: в) хотя бы один мяч белый? \n'
formula += 'Необходиом использовать формулу сочетания комбинаторики \n'
formula += '$\\ C^k_n = \\frac{n!}{k!\\left(n-k\\right)!}  $\n'
formula += 'и классическую формулу вероятности. \n'
formula += '$\\ P(A) = \\frac{m}{n} $\n'

formula += 'Так же использовать то, что сумма вероятности противоположных событий равно 1 \n'
formula += '$\\ P(A) + P( \\overline{A})=\\ {1} $\n'
formula += 'где '
formula += '$\\ P( \\overline{A}) $'
formula += ' - исход, не было извлечено ни одного белого мяча. \n'
formula += '$\\ {m_1} $'
formula += ' количество благоприятных исходов, извлечений из первого ящика 0 белых мячей из 7 \n'
formula += '$\\ {m_1} : \\ C^k_n = С^{2}_{3} $ \n'
formula += '$\\ {n_1} $'
formula += ' количество извлечения из первого ящика 2-х мячей из 10. \n'
formula += '$\\ {n_1} : \\ C^k_n = С^{2}_{10} $\n'
formula += '$\\ {m_2} $'
formula += ' количество благоприятных исходов, извлечений из второго ящика 0 белых мячей из 9 \n'
formula += '$\\ {m_2} : \\ C^k_n = С^{2}_{2} $ \n'
formula += '$\\ {n_2} $'
formula += ' количество извлечения из второго ящика 2-х мячей из 11. \n'
formula += '$\\ {n_2} : \\ C^k_n = С^{2}_{11} $\n'
formula += '$\\ Вероятность \\ одновременного \\ наступления \\ события \\ P( \\overline{A}) \\ вычисляется, \\ как: $ \n'
formula += '$\\ P( \\overline{A}) = \\frac{m_1}{n_1} * \\frac{m_2}{n_2} $\n'

# Вычислим  m1 и m2
m1 = combinatorics(3, 2)
m2 = combinatorics(2, 2)
formula += 'Вычислим  $\\ {m_1} \\ {и} \\ {m_2} $ \n'
formula += '$\\ {m_1}=' + str(m1) + ' \\ {и} \\ {m_2}=' + str(m2) + ' $ \n'

# Вычислим  n1 и n2
n1 = combinatorics(10, 2)
n2 = combinatorics(11, 2)
formula += 'Вычислим  $\\ {n_1} \\ {и} \\ {n_2} $ \n'
formula += '$\\ {n_1}=' + str(n1) + ' \\ {и} \\ {n_2}=' + str(n2) + ' $ \n'

# Вычислим  P_A и P
P_A = (m1 / n1) * (m2 / n2)
P = 1 - P_A
formula += 'Вычислим  $\\ P( \\overline{A}) \\ {и} \\ {P} $ \n'
formula += '$\\ P( \\overline{A}) =' + str(round(P_A,4)) + '\\ {и} \\ {P}=' + str(round(P,4)) + ' $ \n'

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


