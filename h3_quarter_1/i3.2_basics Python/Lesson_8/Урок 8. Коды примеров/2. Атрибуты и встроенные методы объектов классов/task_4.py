class User():

    def __init__(self, name, login, passwd, email):
        self.name = name
        self.login = login
        self.passwd = passwd
        self.email = email
    @property
    def on_get_data(self):
        print(f"имя: {self.name}, логин: {self.login}, "
            f"пароль: {self.passwd}, email: {self.email}")


"""
имя: Ivan Ivanov, логин: IvIv, пароль: 11111, email: iviv@mail.ru
__name__ - User, 
 __module__ - __main__, 
__dict__ - {'__module__': '__main__', '__init__': <function User.__init__ at 0x000001D4E24485E8>, 'on_get_data': <function User.on_get_data at 0x000001D4E259C288>, '__dict__': <attribute '__dict__' of 'User' objects>, '__weakref__': <attribute '__weakref__' of 'User' objects>, '__doc__': None}, 
 __bases__ - (<class 'object'>,), 
__doc__ - None, 
 __class__ - <class 'type'>, 
__init__ - <function User.__init__ at 0x000001D4E24485E8>, 
 __hash__ - <slot wrapper '__hash__' of 'object' objects>
"""

u = User("Ivan Ivanov", "IvIv", "11111", "iviv@mail.ru")
u.on_get_data()
print(f"__name__ - {User.__name__}, \n __module__ - {User.__module__}, \n"
    f"__dict__ - {User.__dict__}, \n __bases__ - {User.__bases__}, \n"
    f"__doc__ - {User.__doc__}, \n __class__ - {User.__class__}, \n"
    f"__init__ - {User.__init__}, \n __hash__ - {User.__hash__}")

"""
имя: Ivan Ivanov, логин: IvIv, пароль: 11111, email: iviv@mail.ru
__name__ - User, 
 __module__ - __main__, 
__dict__ - {'__module__': '__main__', '__init__': <function User.__init__ at 0x000001D4E24485E8>, 'on_get_data': <function User.on_get_data at 0x000001D4E259C288>, '__dict__': <attribute '__dict__' of 'User' objects>, '__weakref__': <attribute '__weakref__' of 'User' objects>, '__doc__': None}, 
 __bases__ - (<class 'object'>,), 
__doc__ - None, 
 __class__ - <class 'type'>, 
__init__ - <function User.__init__ at 0x000001D4E24485E8>, 
 __hash__ - <slot wrapper '__hash__' of 'object' objects>
"""
