class User:
    def __init__(self, name, login, passwd, email):
        self.name = name
        self.login = login
        self.passwd = passwd
        self.email = email
    def on_get_data(self):
        print(f"имя: {self.name}, логин: {self.login}, "
            f"пароль: {self.passwd}, email: {self.email}")


u = User("Ivan Ivanov", "IvIv", "11111", "iviv@mail.ru")
u.on_get_data()
print(f"__name__ - {User.__name__}, \n __module__ - {User.__module__}, \n"
    f"__dict__ - {User.__dict__}, \n __bases__ - {User.__bases__}, \n"
    f"__doc__ - {User.__doc__}, \n __class__ - {User.__class__}, \n"
    f"__init__ - {User.__init__}, \n __hash__ - {User.__hash__}")
