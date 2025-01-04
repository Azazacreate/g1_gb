/* Задание No1
Создайте таблицу с именем «OrderStatus». со столбцами 
OrderStatusID, OrderID (INT), Status (VARCHAR) */
DROP TABLE shop.OrderStatus;
CREATE TABLE shop.OrderStatus
(order_status_id INT PRIMARY KEY AUTO_INCREMENT
,order_id INT
,status VARCHAR(30)
)


/* Задание No2
Вставьте образец данных в таблицу «OrderStatus». 
Поле для OrderID 101 со статусом 'Shipped'. */
INSERT INTO shop.OrderStatus
(order_id, status)
VALUES(101, 'Shipped');


/* Задание No3
Обновите параметр OrderStatus' идентификатора заказа 
101 на 'Delivered'. */
UPDATE shop.OrderStatus
SET status='Delivered'
WHERE order_id=101;


/* Задание No4
Создайте представление с именем «DeliveredOrders». 
которое отображает OrderID и OrderDate для заказов 
со статусом 'Delivered' */
CREATE VIEW shop.view_ordersDelivered AS
SELECT os.order_id, o.OrderDate, status
FROM shop.OrderStatus os
JOIN shop.Orders o ON os.order_id = o.OrderID
WHERE status IN ('Delivered')


# 4.2[
UPDATE shop.OrderStatus
SET status = 'Delivered'
WHERE order_status_id = 2;

SELECT * FROM shop.view_ordersdelivered vo 


/* Задание No5
Создайте процедуру с именем «UpdateOrderStatus». 
который принимает OrderID и Status в качестве 
параметров
и обновляет статус в 'OrderStatus'. */
CALL shop.sp_update__status(1, 'shipped');


/* Задание No6
Создайте таблицу с именем «EmployeeRoles». со столбцами 
EmployeeRoleID, EmployeeID (INT), Role (VARCHAR). */
CREATE TABLE shop.employee_roles
(employee_role_id INT AUTO_INCREMENT PRIMARY KEY
,employee_id INT
,role VARCHAR(30)
)


/* Задание No7
Вставьте образец данных в поле 'EmployeeRoles' 
таблица для идентификатора сотрудника 1 с должностью 
'Manager'. */
INSERT INTO shop.employee_roles
SET 
	employee_id = 2
	,`Role` = 'Manager'
;


/* Задание No8
Создайте представление с именем «EmployeeRolesView». 
который отображает идентификатор сотрудника, фамилию 
и роль для сотрудников с должностью. */


/* Задание No9
Создайте процедуру с именем «AssignEmployeeRole». 
который принимает идентификатор сотрудника и роль 
в качестве параметров и вставляет новую должность
в 'EmployeeRoles'. */


/* Задание No10
Создайте представление с именем «HighValueOrdersView». 
который отображает OrderID, CustomerID и OrderDate 
для заказов, общая стоимость которых превышает 
500 долларов США. */


# Домашнее задание
/* 1. Создайте хранимую процедуру с именем 
 * «GetEmployeeOrders». который принимает идентификатор 
 * сотрудника в качестве параметра и возвращает все 
 * заказы, обработанные этим сотрудником.
Пропишите запрос, который создаст требуемую процедуру. */
CALL shop.GetEmployeeOrders(1);


/* 2. Создайте таблицу EmployeeRoles, как на уроке и 
 * удалите ее.
Напишите запрос, который удалит нужную таблицу. */
CREATE TABLE shop.Employee_Roles_HW
(Employee_Roles_ID INT AUTO_INCREMENT PRIMARY KEY
,employee_id INT
,role VARCHAR(30)
)
DROP TABLE shop.Employee_Roles


/* 3. Удалите все заказы со статусом 'Delivered' из 
 * таблицы OrderStatus, которую создавали на семинаре
Напишите запрос, который удалит нужные строки в таблице. */
DELETE FROM shop.OrderStatus
WHERE status = 'Delivered'

