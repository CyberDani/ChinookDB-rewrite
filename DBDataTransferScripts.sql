/*******************************************************************************
  Feltoltes adatokkal
  -------------------
  Ures adatbazisra alkalmazd, mert maskepp meg fogja duplazni az adatokat!
********************************************************************************/

use BI_source

INSERT INTO Artist(AName)
SELECT DISTINCT Name AS AName FROM Chinook.dbo.Artist


INSERT INTO MediaType(MName)
SELECT DISTINCT Name AS MName FROM Chinook.dbo.MediaType


INSERT INTO Genre(GName)
SELECT DISTINCT Name AS GName FROM Chinook.dbo.Genre


CREATE PROCEDURE TransferAlbum
AS
BEGIN
	SELECT cart.ArtistId,biart.Id
	INTO #ArtistData 
	FROM Chinook.dbo.Artist cart, BI_source.dbo.Artist biart
	WHERE AName= cart.Name

	INSERT INTO BI_source.dbo.Album(Title,ArtistId,ReleaseDate)
	SELECT Title,ad.Id,DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 3650), '2000-01-01') 
	FROM Chinook.dbo.Album calb, #ArtistData ad 
	WHERE calb.ArtistId=ad.ArtistId
END

--DROP PROCEDURE TransferAlbum 
EXECUTE TransferAlbum

-- Collect countries among tables
INSERT INTO Country(CName)
SELECT DISTINCT Country AS CName FROM Chinook.dbo.Customer
	UNION
SELECT DISTINCT Country AS CName FROM Chinook.dbo.Employee
	UNION
SELECT DISTINCT BillingCountry AS CName FROM Chinook.dbo.Invoice

INSERT INTO BI_source.dbo.Customer(FirstName,LastName,Phone,Fax,Email)
SELECT FirstName,LastName,Phone,Fax,Email FROM Chinook.dbo.Customer


