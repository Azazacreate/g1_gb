import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report

# Задание 1.
df = pd.read_csv('1.csv')

# Задание 2: Разметка на основе правил
def label_based_on_rules(review):
    positive_words = ["отличный", "замечательный", "прекрасный", "нравится", "рекомендую", "восхитительный", 'чудесный', 'красивый']
    negative_words = ["ужасный", "плохой", "не нравится", "не рекомендую", "разочарован", "грустный"]

    if any(word in review for word in positive_words):
        return "положительный"
    elif any(word in review for word in negative_words):
        return "отрицательный"
    else:
        return "нейтральный"


df['Метка_по_правилам'] = df['Отзыв'].apply(label_based_on_rules)

# Задание 3. Вручную
# 15 отзывов
manual_labels = [
    "положительный", "отрицательный", "нейтральный", "положительный", "отрицательный",
    "положительный", "отрицательный", "нейтральный", "положительный", "отрицательный",
    "положительный", "отрицательный", "нейтральный", "положительный", "отрицательный"
]

if len(manual_labels) != len(df):
    raise ValueError("Количество меток не совпадает с количеством отзывов.")

df['Метка_вручную'] = manual_labels

# Задание 4.
combined_df = df[['Отзыв', 'Метка_по_правилам', 'Метка_вручную']]

# Задание 5.
X = combined_df['Отзыв']
y = combined_df['Метка_вручную']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

vectorizer = TfidfVectorizer()
X_train_tfidf = vectorizer.fit_transform(X_train)
X_test_tfidf = vectorizer.transform(X_test)

model = LogisticRegression()
model.fit(X_train_tfidf, y_train)

# Задание 6.
y_pred = model.predict(X_test_tfidf)
accuracy = accuracy_score(y_test, y_pred)
report = classification_report(y_test, y_pred, zero_division=0)
print(f"Точность модели: {accuracy:.2f}")
print("Отчет о классификации:\n", report)


# добавил визуализации
sns.countplot(x='Метка_по_правилам', data=combined_df)
plt.title('Распределение меток по правилам')
plt.xlabel('Метка')
plt.ylabel('Количество')
plt.show()