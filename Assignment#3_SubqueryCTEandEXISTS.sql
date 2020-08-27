USE AdventureWorks2012;

--Exercise 1: change hireDate format to MM/DD/YY
GO
SELECT CONVERT (Varchar(10), HireDate, 1) AS NewHireDate
FROM HumanResources.Employee;

/*Exercise 2 part 1: write separate queries using join, subquery,
CTE, and EXISTS to list everyone who has not placed an order*/
GO --part 1: use join
SELECT DISTINCT p.BusinessEntityID, p.LastName, p.FirstName
FROM Person.Person p
LEFT JOIN Sales.Customer c
	ON p.BusinessEntityID = c.PersonID
LEFT JOIN Sales.SalesOrderHeader soh
	ON c.CustomerID = soh.CustomerID
WHERE SalesOrderID IS NULL

GO --part 2: use subquery
SELECT DISTINCT p.BusinessEntityID, p.LastName, p.FirstName
FROM Person.Person p
WHERE p.BusinessEntityID NOT IN (
	SELECT c.PersonID
	FROM Sales.Customer c
	JOIN Sales.SalesOrderHeader soh
		ON c.CustomerID = soh.CustomerID
)
ORDER BY p.BusinessEntityID;

GO --part3: use CTE
WITH PayingCustomers (BusinessEntityID) AS (
	SELECT DISTINCT c.PersonID
	FROM Sales.Customer c
	JOIN sales.SalesOrderHeader soh
		ON c.CustomerID = soh.CustomerID
)
SELECT DISTINCT p.BusinessEntityID, p.LastName, p.FirstName
FROM Person.Person p
LEFT JOIN PayingCustomers pc
	ON pc.BusinessEntityID = p.BusinessEntityID
WHERE pc.BusinessEntityID IS NULL
ORDER BY p.BusinessEntityID

GO -- part4: use EXISTS
SELECT DISTINCT p.BusinessEntityID, p.LastName, p.FirstName
FROM Person.Person p
WHERE NOT EXISTS (
	SELECT *
	FROM Sales.Customer c
	JOIN Sales.SalesOrderHeader soh
		ON c.CustomerID = soh.CustomerID
	WHERE c.PersonID = P.BusinessEntityID
)
ORDER BY p.BusinessEntityID

--Exercise 3: find the five most recent orders from accounts that have spent over 70000
GO
--find accounts that have spent over 70000 
WITH Over70000 AS (
	SELECT CustomerID
	FROM Sales.SalesOrderHeader soh
	GROUP BY CustomerID
	HAVING SUM(TotalDue) > 70000
), 
--find the five most recent orders from each account
RecentOrders AS (
	SELECT soh.CustomerID, soh.SalesOrderID, soh.OrderDate, soh.TotalDue,
		ROW_NUMBER() OVER (PARTITION BY soh.CustomerID ORDER BY OrderDate DESC) RowNum
	FROM Sales.SalesOrderHeader soh
	JOIN Over70000 o
		ON soh.CustomerID = o.CustomerID
)
SELECT CustomerID, SalesOrderID, OrderDate, TotalDue
FROM RecentOrders
WHERE RowNum <= 5
ORDER BY CustomerID, RowNum