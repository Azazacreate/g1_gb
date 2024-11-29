-- HomeWork-5
/* 1} Создайте хранимую процедуру с именем 
«GetEmployeeOrders». который принимает идентификатор 
сотрудника в качестве параметра и возвращает все заказы, 
обработанные этим сотрудником.
Пропишите запрос, который создаст требуемую процедуру. */
CREATE PROCEDURE GetEmployeeOrders
    @EmployeeID INT
AS
BEGIN
    SELECT *
    FROM Orders
    WHERE EmployeeID = @EmployeeID;
END;

/* 2} Создайте таблицу EmployeeRoles, как на уроке и 
удалите ее.
Напишите запрос, который удалит нужную таблицу. */
-- Создание таблицы EmployeeRoles
CREATE TABLE EmployeeRoles (
    RoleID INT PRIMARY KEY,
    RoleName NVARCHAR(50)
);

-- Удаление таблицы EmployeeRoles
DROP TABLE EmployeeRoles;

/* 3}  Удалите все заказы со статусом 'Delivered' из 
таблицы OrderStatus, которую создавали на семинаре
Напишите запрос, который удалит нужные строки в таблице. */
DELETE FROM OrderStatus
WHERE Status = 'Delivered';