var1 = '5 4' # количество элементов первого и второго множества
var2 = '10 20 30 40 50' # элементы первого множества через пробел
var3 = '10 20 30 40 50' # элементы второго множества через пробел

m_var2 = set(var2.split())
m_var3 = set(var3.split())
a = sorted(m_var2.intersection(m_var3))
print(*a)
print(m_var2)