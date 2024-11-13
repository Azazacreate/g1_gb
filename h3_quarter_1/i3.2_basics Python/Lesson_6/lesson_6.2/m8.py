class Auto:
    auto_count = 0
    def def1(self, auto_name, auto_model, auto_year):
        self.auto_name = auto_name
        self.auto_model = auto_model
        self.auto_year = auto_year
        self.auto_count += 1
        Auto.auto_count += 1
a_1 = Auto()
a_2 = Auto()
a_1.def1("name_1", "model_1", 1999)
a_2.def1("name_2", "model_2", 2000)
print(a_1.auto_name, a_1.auto_model, a_1.auto_year, a_1.auto_count)
print(a_2.auto_name, a_2.auto_model, a_2.auto_year, a_2.auto_count)
a_2.def1("name_2", "model_2", 2000)
print(a_2.auto_name, a_2.auto_model, a_2.auto_year, a_2.auto_count)
print(Auto.auto_count)