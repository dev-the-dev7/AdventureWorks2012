USE AdventureWorks2012;

GO -- Exercise 1: find last name of employee with the national ID number 112457891
SELECT LastName Name
FROM HumanResources.Employee e
JOIN Person.Person p
	ON e.BusinessEntityID = p.BusinessEntityID
WHERE NationalIDNumber = 112457891

GO -- Exercise 2: find products without a discount and products with no special offer
SELECT p.ProductID, p.Name 
FROM Production.Product p 
LEFT JOIN Sales.SpecialOfferProduct sop
ON p.ProductID = sop.ProductID
LEFT JOIN Sales.SpecialOffer so
ON so.SpecialOfferID = sop.SpecialOfferID
WHERE so.Description = 'No Discount' OR sop.SpecialOfferID IS NULL 