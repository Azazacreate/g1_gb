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