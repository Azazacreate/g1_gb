-- lesson_6
-- создать таблицу:пустую с-2-полями.
CREATE TABLE shop.demo3 (dt date, cnt int)


-- MySQL, Hadoop
DROP TABLE IF EXISTS shop.Planets


-- MS SQL
IF OBJECT_ID('demo2') IS NOT NULL
BEGIN
	DROP TABLE demo2
END


-- 1.7[
CREATE TABLE shop.Planets (
	ID INT NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (ID),
	PlanetName VARCHAR(10) NOT NULL,
	Radius FLOAT,
	SunSeason FLOAT,
	OpeningYear INT,
	HavingRings BIT,
	Opener VARCHAR(30)
)


-- 1.8[ создание представлений
-- создание представлений = сохранить запрос в-БД
-- сохранить запрос как-представление
CREATE VIEW view_name AS 
SELECT column1, column2, ...
FROM table_name
WHERE CONDITION ;


-- заказчик должен-написать, чтобы увидеть данные:нужные
SELECT * FROM view_name


-- 1.9[ создание процедур
-- автоматизировать части_работы
CREATE PROCEDURE procedure_name(parametrs) AS
	BEGIN
		OPERATORS
	END

	
-- 1.9.2[ MS SQL
CREATE PROCEDURE shop.s_s @TN VARCHAR(50), @N INT = 10 -- simple_select
AS
BEGIN
	DECLARE @query VARCHAR(1000)
SET @query = 'SELECT TOP('+CAST(@N AS VARCHAR(10)) + ') * FROM ' + @TN
EXEC(@query)
END


-- 1.9.3[ MySQL
-- хз, как сделать здесь.