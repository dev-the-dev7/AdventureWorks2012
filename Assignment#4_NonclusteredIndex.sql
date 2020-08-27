USE AdventureWorks2012;

GO -- create a nonclustered index
CREATE NONCLUSTERED INDEX IX_ProductModel_ModifiedDate
	ON Production.ProductModel (ModifiedDate);

GO -- delete nonclustered index
IF EXISTS (SELECT name FROM sys.indexes
			WHERE name = N'IX_ProductModel_ModifiedDate')
DROP INDEX IX_ProductModel_ModifiedDate 
	ON Production.ProductModel;