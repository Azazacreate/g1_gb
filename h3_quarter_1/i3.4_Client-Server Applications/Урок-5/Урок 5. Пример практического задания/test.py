def func():
    pass


func()


class Log:
    def __call__(self, *args, **kwargs):
        pass

call_obj = Log()
call_obj()
