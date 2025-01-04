-- hw_4
/* 1.Ранжируйте продукты (по ProductRank) в каждой 
категории на основе их общего объема продаж 
(TotalSales). */
SELECT DISTINCT
	p.CategoryID
	,od.ProductID
	,RANK() OVER(ORDER BY SUM(price * Quantity)) AS rank1
	,SUM(price * Quantity)
FROM shop.orders o
JOIN shop.orderdetails od ON o.OrderID = od.OrderID 
JOIN shop.products p ON od.ProductID = p.ProductID 
JOIN shop.categories c ON p.CategoryID = c.CategoryID
GROUP BY p.CategoryID, od.ProductID
ORDER BY p.CategoryID, od.ProductID


/* 2. Обратимся к таблице Clusters
Рассчитайте среднюю сумму кредита (AvgCreditAmount) 
для каждого кластера и месяца, учитывая общую среднюю 
сумму кредита за соответствующий месяц 
(OverallAvgCreditAmount).
Определите OverallAvgCreditAmount в первой строке 
результатов запроса. */
SELECT
	'All Months' AS month
	,NULL AS cluster
	,'a' AS AvgCreditAmount
	,AVG(credit_amount) AS OverallAvgCreditAmount
FROM shop.clusters
UNION ALL
SELECT 
	month
	,cluster
	,AVG(credit_amount) OVER(PARTITION BY cluster, `month`)
	,AVG(credit_amount) OVER(PARTITION BY `month`)
FROM shop.clusters c


/* 3.Сопоставьте совокупную сумму сумм кредита 
(CumulativeSum) для каждого кластера, упорядоченную 
по месяцам, и сумму кредита в порядке возрастания.
Определите CumulativeSum в первой строке результатов 
запроса. */
SELECT 
	'CLUSTERS' AS cluster
	,'MONTS' AS month
	,SUM(credit_amount) AS CumulativeSum
FROM shop.clusters c 
UNION
SELECT DISTINCT
	cluster
	,`month` 
	,SUM(credit_amount) OVER(PARTITION BY cluster ORDER BY month)
FROM shop.clusters c 