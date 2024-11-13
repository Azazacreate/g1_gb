class ArrayOnly:
    def __init__(self, attr):
        self.attr = attr

    def __set__(self, instance, value):
        if type(value) != list:
            raise TypeError('Матрица должна принимать список (массив).')
        instance.__dict__[self.attr] = value


class Matrix:
    lists_matrix = ArrayOnly('list_of_lists')

    def __init__(self, list_of_lists):
        self.lists_matrix = list_of_lists

    def __str__(self):
        new_string = ''
        for el in self.lists_matrix:
            for el2 in el:
                new_string += f'{el2}  '
            new_string += '\n'
        return new_string


array = '!'
user_matrix = Matrix(array)


