"""Примеры asserts"""


def assert_equal(val_1, val_2):
    """Сравнение чисел"""
    assert val_1 == val_2, f"{val_1} != {val_2}"


assert_equal(4, 3)
