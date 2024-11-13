import pandas as pd


# task_1
df = pd.read_csv("a2.csv")
print(df.head(n = 5))


# task_2
print(df.isnull().sum())    # нет ячеек:пропущенных