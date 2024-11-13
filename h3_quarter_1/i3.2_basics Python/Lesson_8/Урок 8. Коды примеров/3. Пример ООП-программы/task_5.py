class Person:
    weight = 1
    def __init__(self, name, surname):
        self.__name = name
        self.surname = surname

    def __str__(self):
        return f"Name and surname: {self.name} {self.surname}"

    def func(self):
        pass


class Teacher(Person):
    def to_teach(self, subj, *pupils):
        for pupil in pupils:
            pupil.to_take(subj)


class Pupil(Person):
    def __init__(self, name, surname):
        super().__init__(name, surname)
        self.knowledges = []

    def to_take(self, subj):
        self.knowledges.append(subj)


class Subject:
    def __init__(self, *subjects):
        self.subjects = list(subjects)

    def my_list(self):
        return self.subjects


s = Subject("maths", "physics", "chemistry")
t = Teacher("Ivan", "Ivanov")
print(t)

p_1 = Pupil("Petr", "Petrov")
p_2 = Pupil("Sergey", "Sergeev")
p_3 = Pupil("Vladimir", "Vladimirov")
print(f"{p_1}; {p_2}; {p_3}")

t.to_teach(s, p_1, p_2, p_3)
print(p_1.knowledges[0].my_list())

"""
Name and surname: Ivan Ivanov
Name and surname: Petr Petrov; Name and surname: Sergey Sergeev; 
Name and surname: Vladimir Vladimirov
['maths', 'physics', 'chemistry']
"""
