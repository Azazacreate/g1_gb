/* Задание-6
Рассчитайте процент от общего объема (выручки) продаж
каждого продукта в своей категории.*/

-- рассчитал просто-выручку
SELECT DISTINCT p.categoryid
	,od.ProductID
	,SUM(quantity * price) OVER(PARTITION BY p.CategoryID, od.ProductID)
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
ORDER BY p.categoryid, od.ProductID


-- процент от выручки
select categoryid, productname, sum(price*quantity) / sum(sum(price*quantity)) over (partition by categoryid) * 100 as cash_pwrc from OrderDetails od
join Products p on od.productid = p.productid
group by productname, categoryid
order by categoryid, productname, sum(price*quantity) / sum(sum(price*quantity)) over (partition by categoryid) desc


/* Задание-7
Для каждого заказа сделайте новую колонку в которой определите 
общий объем продаж за каждый месяц, учитывая все годы. */
SELECT DISTINCT 
	YEAR(o.OrderDate)
	,MONTH(o.OrderDate)
	,SUM(price * Quantity) OVER(PARTITION BY YEAR(o.OrderDate), MONTH(o.OrderDate))
FROM Orders o 
JOIN OrderDetails od ON o.OrderID = od.OrderID 
JOIN Products p ON od.ProductID = p.ProductID