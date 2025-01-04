-- HomeWork-5
/* 1} Создайте хранимую процедуру с именем 
«GetEmployeeOrders». который принимает идентификатор 
сотрудника в качестве параметра и возвращает все заказы, 
обработанные этим сотрудником.
Пропишите запрос, который создаст требуемую процедуру. */
CALL shop.GetEmployeeOrders(1)


/* # PROCEDURE
DROP PROCEDURE IF EXISTS shop.GetEmployeeOrders;
    
DELIMITER $$
$$
CREATE PROCEDURE shop.GetEmployeeOrders(_id_employee int)
BEGIN
	SELECT *
	FROM shop.orders o 
	WHERE EmployeeID = _id_employee;
END$$
DELIMITER ; */


/* 2} Создайте таблицу EmployeeRoles, как на уроке и 
удалите ее.
Напишите запрос, который удалит нужную таблицу. */
-- Создание таблицы EmployeeRoles
CREATE TABLE shop.Employee_Roles_HW
(Employee_Roles_ID INT AUTO_INCREMENT PRIMARY KEY
,employee_id INT
,role VARCHAR(30)
)
DROP TABLE shop.Employee_Roles;


/* 3}  Удалите все заказы со статусом 'Delivered' из 
таблицы OrderStatus, которую создавали на семинаре
Напишите запрос, который удалит нужные строки в таблице. */
DELETE FROM shop.OrderStatus
WHERE status = 'Delivered';