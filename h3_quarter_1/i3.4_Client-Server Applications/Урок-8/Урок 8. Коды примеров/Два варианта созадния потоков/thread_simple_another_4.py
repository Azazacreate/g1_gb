"""Поток с объектами-событиями"""

import threading

# args=('Я-второй поток', EVENT_2, EVENT_1)
def writer(mes, event_for_wait, event_for_set):
    """
    функция принимает на вход некий параметр, событие, которое ожидают
    и еще одно событие, для которого необходимо установить True
    :param mes:
    :param event_for_wait:
    :param event_for_set:
    :return:
    """
    for _ in range(10):
        # ожидать событие
        event_for_wait.wait()
        print(mes)
        # сбросить флаг события на false
        event_for_wait.clear()
        # выводим параметр

        # устанавливаем флаг True для второго события
        # потоки, которые его ожидают, активизируются
        event_for_set.set()


# определяем объекты-события
# это объекты-наблюдатели
EVENT_1 = threading.Event()
EVENT_2 = threading.Event()

# определяем потоки
# в каждом потоке запускаем на выполнение ф-цию writer
# args - позиционные аргументы для ф-ции writer
# 0 или 1, как выодимое значение
# EVENT_1, EVENT_2 - объекты событий
THR_1 = threading.Thread(target=writer, args=('Я-первый поток',
                                              EVENT_2, EVENT_1), daemon=True)
THR_2 = threading.Thread(target=writer, args=('Я-второй поток',
                                              EVENT_1, EVENT_2), daemon=True)

# запускаем потоки
THR_1.start()
THR_2.start()

# устанавливаем значение True
# потоки, которые этого ждут - пробуждаются
EVENT_2.set()

# ждем, пока завершатся запущенные потоки
# Ждем, пока поток не закончится. Это блокирует вызывающий поток до тех пор,
# пока поток, чей метод join() вызывается, не завершится
THR_1.join()
THR_2.join()
