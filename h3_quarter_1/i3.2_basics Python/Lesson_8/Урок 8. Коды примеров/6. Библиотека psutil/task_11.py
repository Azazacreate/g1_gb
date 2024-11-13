import psutil

#  Информация о системных вызовах и контекстных переключателях
print(psutil.cpu_stats())

#  Информация о диске
print(psutil.disk_usage("D:"))

#  Информация о состоянии памяти
print(psutil.virtual_memory())

"""
scpustats(ctx_switches=114348370, interrupts=82595974, soft_interrupts=0, syscalls=472501052)
sdiskusage(total=2041184256, used=2029060096, free=12124160, percent=99.4)
svmem(total=6388346880, available=2077708288, percent=67.5, used=4310638592, free=2077708288)
"""
