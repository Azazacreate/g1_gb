

# Деление на ноль недопустимо

try:
    res = 100/0
except Exception:
    print("На ноль делить нельзя")
except ValueError:
    print("")
else:
    print(f"Все хорошо. Результат - {res}")
finally:
    print("Программа завершена")

print("!")
