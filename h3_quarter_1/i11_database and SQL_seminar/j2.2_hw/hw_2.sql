--	Homework_4
/* 1} Вам необходимо проверить влияние семейного положения 
(family_status) на средний доход клиентов (income) 
и запрашиваемый кредит (credit_amount) . */
SELECT family_status, COUNT(*) as cnt, AVG(income) as incomeAvg, AVG(credit_amount) as creditAvg
FROM Clusters
GROUP BY family_status
ORDER BY AVG(income), AVG(credit_amount);
-- не-нашел разницы:существенной.


/* 2} Сколько товаров в категории Meat/Poultry. */
SELECT COUNT(*)
FROM Products
WHERE categoryid IN
	(select categoryid
    from Categories
    WHERE categoryname = 'Meat/Poultry');
-- 6


/* 3} Какой товар (название) заказывали в сумме 
в самом большом количестве (sum(Quantity) 
в таблице OrderDetails) ? */
SELECT productname
FROM Products
WHERE productid IN 
    (SELECT TOP 1 productid
    FROM OrderDetails
    GROUP BY productid
    ORDER by sum(quantity) DESC)
-- Gorgonzola Telino