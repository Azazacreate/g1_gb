--1} Посчитать средний чек одного заказа.
WITH sum1 as
  (SELECT o.OrderID, SUM(quantity * price) as sum1
  FROM Orders o
  JOIN OrderDetails od
      ON o.OrderID = od.OrderID
  JOIN Products p
      ON od.ProductID = p.ProductID
  GROUP BY o.OrderID)
SELECT ROUND(AVG(sum1), 1) AS sum2
FROM sum1




/* 2} Посчитать сколько заказов доставляет в месяц каждая служба доставки. 
--Определите, сколько заказов доставила United
--Package в декабре 2023 года */
/* 3} Определить средний LTV покупателя (сколько денег покупатели в среднем тратят в магазине за весь период) */