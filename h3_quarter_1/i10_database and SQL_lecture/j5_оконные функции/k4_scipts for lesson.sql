-- lection-5
-- оконные функции
SELECT 
	CategoryID 
	,ProductName
	,SUM(Price) OVER (PARTITION BY CategoryID) AS sum_Price
	,AVG(Price) OVER (PARTITION BY CategoryID) AS avg_Price
	,COUNT(Price) OVER (PARTITION BY CategoryID) AS count_Price
	,MIN(Price) OVER (PARTITION BY CategoryID) AS min_Price
	,MAX(Price) OVER (PARTITION BY CategoryID) AS max_Price
FROM Products p 
ORDER BY CategoryID, Price, ProductName