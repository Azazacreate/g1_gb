"""
2. Задание на закрепление знаний по модулю json. Есть файл orders
в формате JSON с информацией о заказах. Написать скрипт, автоматизирующий
его заполнение данными.

Для этого:
Создать функцию write_order_to_json(), в которую передается
5 параметров — товар (item), количество (quantity), цена (price),
покупатель (buyer), дата (date). Функция должна предусматривать запись
данных в виде словаря в файл orders.json. При записи данных указать
величину отступа в 4 пробельных символа;
Проверить работу программы через вызов функции write_order_to_json()
с передачей в нее значений каждого параметра.

ПРОШУ ВАС НЕ УДАЛЯТЬ ИСХОДНЫЙ JSON-ФАЙЛ
ПРИМЕР ТОГО, ЧТО ДОЛЖНО ПОЛУЧИТЬСЯ

{
    "orders": [
        {
            "item": "printer",
            "quantity": "10",
            "price": "6700",
            "buyer": "Ivanov I.I.",
            "date": "24.09.2017"
        },
        {
            "item": "scaner",
            "quantity": "20",
            "price": "10000",
            "buyer": "Petrov P.P.",
            "date": "11.01.2018"
        }
    ]
}

вам нужно подгрузить JSON-объект
и достучаться до списка, который и нужно пополнять
а потом сохранять все в файл
"""

import json


def write_order_to_json(item, quantity, price, buyer, date):
    """Запись в json"""

    with open('orders_1.json', 'r', encoding='utf-8') as f_out:
        data = json.load(f_out)

    with open('orders_1.json', 'w', encoding='utf-8') as f_in:
        orders_list = data['orders']
        order_info = {'item': item, 'quantity': quantity,
                      'price': price, 'buyer': buyer, 'date': date}
        orders_list.append(order_info)
        # используем параметр ensure_ascii=False
        # Если ensure_ascii = True, все не-ASCII символы в выводе будут экранированы
        # последовательностями \uXXXX, и результатом будет строка, содержащая только ASCII символы.
        # Если ensure_ascii = False, строки запишутся как есть.
        json.dump(data, f_in, indent=4, ensure_ascii=False)


write_order_to_json('принтер', '10', '6700', 'Ivanov I.I.', '24.09.2017')
write_order_to_json('сканер', '20', '10000', 'Petrov P.P.', '11.01.2018')
write_order_to_json('компьютер', '5', '40000', 'Sidorov S.S.', '2.05.2019')
