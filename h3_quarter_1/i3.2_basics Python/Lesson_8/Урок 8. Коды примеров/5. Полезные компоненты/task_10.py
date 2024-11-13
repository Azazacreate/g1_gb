# Установка virtualenv:
pip install virtualenv

# Создание виртуальной среды для проекта:
virtualenv my_proj

# Альтернативная команда создания виртуальной среды для проекта:
python -m venv my_proj

# Активация виртуальной среды (для Windows):
my_venc\Scripts\activate

# Активация виртуальной среды (для Linux и MacOs):
source my_proj/venv/bin/activate

# Теперь все устанавливаемые приложения будут размещаться в текущей виртуальной среде.
# Деактивация виртуальной среды (для Windows):
my_proj\Scripts\deactivate

# Деактивация виртуальной среды (для Linux и MacOs):
source deactivate
