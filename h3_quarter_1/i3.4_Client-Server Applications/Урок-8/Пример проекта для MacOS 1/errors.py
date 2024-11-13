
class UsernameToLongError(Exception):
    def __init__(self, username):
        self.username = username

    def __str__(self):
        return f'Имя пользователя {self.username} должно быть менее 26 символов'