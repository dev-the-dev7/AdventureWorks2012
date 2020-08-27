USE AdventureWorks2012;

--create an invoice providing the CustomerName, ItemName, OrderQty, Price, TaxRate,
--SalePerson, SalesPersonID, OrderDate, ShipDate, Address, City, and PostalCode
GO --make a temporary table to store the sales persons' names along with their id
DECLARE @TempTable Table (
	SalesPerson varchar(30),
	SalesPersonID int)

--insert the data from the person.person table
INSERT INTO @TempTable
	SELECT FirstName + ' ' + LastName AS SalesPerson, BusinessEntityID AS SalesPersonID
	FROM Person.Person
	WHERE Person.PersonType = 'SP'; -- we are only looking for Sales people

--join all the necessary tables and select only the needed data for the invoice
SELECT 
	FirstName + ' ' + LastName AS CustomerName,
	pp.Name AS ItemName,
	OrderQty,
	StandardCost AS Price,
	TaxRate,
	SalesPerson,
	tt.SalesPersonID,
	OrderDate,
	ShipDate,
	AddressLine1 AS Address,
	City,
	PostalCode
FROM Person.Person p
JOIN Sales.Customer c
	ON p.BusinessEntityID = c.PersonID
JOIN Sales.SalesOrderHeader sh
	ON c.CustomerID = sh.CustomerID
JOIN Sales.SalesOrderDetail sd
	ON sd.SalesOrderID = sh.SalesOrderID
JOIN Production.Product pp
	ON pp.ProductID = sd.ProductID
JOIN Person.Address pa
	ON pa.AddressID = sh.ShipToAddressID
JOIN Sales.SalesTaxRate r
	ON r.StateProvinceID = pa.StateProvinceID
JOIN @TempTable tt
	ON tt.SalesPersonID = sh.SalesPersonID;