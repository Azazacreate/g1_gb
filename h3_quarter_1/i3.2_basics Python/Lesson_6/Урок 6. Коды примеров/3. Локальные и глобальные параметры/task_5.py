def func():
    pass

func()


class NewClass:
    def __call__(self, *args, **kwargs):
        print("вызывваемы")


obj = NewClass()
obj()
