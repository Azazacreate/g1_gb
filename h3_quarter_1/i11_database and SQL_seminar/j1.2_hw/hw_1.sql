/* 1} В каких странах проживают наши клиенты (таблица Customers)? 
 * Сколько уникальных стран вы получили в ответе?*/
SELECT COUNT (DISTINCT Country)
FROM Customers;

-- 2} Сколько клиентов проживает в Argentina?
SELECT COUNT (*)
FROM Customers
WHERE Country = 'Argentina';

/* 3} Посчитайте среднюю цену и количество товаров в 8 категории */
SELECT COUNT(*), AVG(Price)
FROM Products
WHERE CategoryID = 8;

-- 4} Посчитайте средний возраст работников (таблица Employees)
SELECT AVG(2024-01-01 - BirthDate) as ageAverange
FROM Employees;

/* 5} Вам необходимо получить заказы, которые сделаны в течении 35 дней до даты 2023-10-10 (то есть с 5 сентября до 10 октября включительно). Использовать функцию DATEDIFF, определить переменные для даты и диапазона.
Определите CustomerID, который оказался в первой строке запроса.*/
SELECT *
FROM Orders
WHERE OrderDate BETWEEN '2023-09-05' AND '2023-10-10';

/* 6} Вам необходимо получить количество заказов за сентябрь месяц (тремя способами, через LIKE, с помощью YEAR и MONTH и сравнение начальной и конечной даты). */ 
-- OPTION-1
SELECT COUNT(*)
FROM Orders
WHERE OrderDate BETWEEN '2023-09-01' AND '2023-09-31';


-- OPTION-2. YEAR & MONTH
SELECT *
FROM Orders
WHERE YEAR(OrderDate) = 2023 AND MONTH(OrderDate) = 9;


-- OPTION-3. LIKE
SELECT COUNT(*)
FROM Orders
WHERE OrderDate LIKE '2023-09%';
