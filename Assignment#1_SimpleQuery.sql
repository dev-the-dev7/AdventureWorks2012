USE AdventureWorks2012;

GO -- find products without a subcategory
SELECT *
FROM Production.Product
WHERE ProductSubcategoryID IS NULL;