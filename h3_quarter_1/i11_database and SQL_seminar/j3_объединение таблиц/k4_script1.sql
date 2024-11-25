/* Задание-1
Приджойним к данным о заказах данные о покупателях. Данные, которые нас интересуют — имя заказчика и страна, из которой совершается покупка. */
SELECT o.*, customername, country
FROM Orders o
INNER JOIN Customers c
	ON o.CustomerID = c.CustomerID

	
/* Задание-2 
Давайте проверим, Customer пришедшие из какой страны 
совершили наибольшее число Orders. Используем сортировку 
по убыванию по полю числа заказов.
И выведем сверху в результирующей таблице название 
лидирующей страны. */
SELECT country, COUNT(*) as cnt
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY country
ORDER BY cnt DESC


/* Задание-3
А теперь напишем запрос, который обеспечит целостное 
представление деталей заказа, включая информацию как 
о клиентах, так и о сотрудниках.
Будем использовать JOIN для соединения информации 
из таблиц Orders, Customers и Employees. */
SELECT *
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID 
JOIN Employees e ON o.EmployeeID = e.EmployeeID 


/* Задание-4
Наша следующая задача — проанализировать данные заказа, рассчитать
ключевые показатели, связанные с выручкой, и соотнести результаты
с ценовой информацией из таблицы Products.
Давайте посмотрим на общую выручку, а также минимальный, 
максимальный чек в разбивке по странам. */
WITH table1 AS
(SELECT o.OrderID, SUM(Price * Quantity) as sum1, Country 
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Customers c ON o.CustomerID = c.CustomerID 
GROUP BY o.OrderID)
SELECT *
FROM table1
UNION ALL
SELECT 'Total', max(sum1), min(sum1)
FROM table1


/* Задание No5
Выведем имена покупателей, которые совершили 
как минимум одну покупку 12 декабря */
SELECT DISTINCT c.CustomerName 
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderDate IN ('2023-12-12')


/* задание-11. дополнительное с-UNION */
SELECT CustomerName, country
FROM Customers c 
WHERE Country = 'Brazil'
UNION
SELECT CustomerName, country
FROM Customers c 
WHERE Country = 'USA'
ORDER BY Country 


-- HomeWork
/* 1} Посчитать средний чек одного заказа. */
WITH table1 AS
	(SELECT SUM(p.Price * od.Quantity) AS sum1
	FROM Orders o 
	JOIN OrderDetails od ON o.OrderID = od.OrderID 
	JOIN Products p ON od.ProductID = p.ProductID 
	GROUP BY o.OrderID )
SELECT ROUND(AVG(sum1), 1)
FROM table1


/* 2} Посчитать сколько заказов доставляет в месяц 
 каждая служба доставки.
Определите, сколько заказов доставила United
Package в декабре 2023 года */
SELECT YEAR(o.OrderDate), MONTH(o.OrderDate), shippername, COUNT(*)
FROM Orders o 
JOIN Shippers s ON o.ShipperID = s.ShipperID 
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate), shippername


SELECT shippername, COUNT(*)
FROM Orders o
JOIN Shippers s ON o.ShipperID = s.ShipperID 
WHERE orderdate LIKE ('%2023-12%')
	AND shippername = 'United Package'
GROUP BY shippername


/* 3} Определить средний LTV покупателя (сколько 
 денег покупатели в среднем тратят в магазине 
 за весь период) */
WITH t AS (
  SELECT SUM(p.Price * od.Quantity) AS sum1
  FROM Orders o 
  JOIN OrderDetails od ON o.OrderID = od.OrderID 
  JOIN Products p ON od.ProductID = p.ProductID 
  JOIN Customers c ON o.CustomerID = c.CustomerID 
  GROUP BY o.CustomerID)
SELECT AVG(sum1)
FROM t