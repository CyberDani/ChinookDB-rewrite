-- Feltoltes adatokkal

use BI_source

INSERT INTO Artis
SELECT SupplierName, City, Country FROM Suppliers;