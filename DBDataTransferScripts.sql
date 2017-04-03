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

IF (OBJECT_ID('TransferAlbum', 'P') IS NOT NULL) 
	DROP PROCEDURE TransferAlbum 
GO

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
GO

--DROP PROCEDURE TransferAlbum 
EXECUTE TransferAlbum
GO

-- Collect countries among tables
INSERT INTO Country(CName)
SELECT DISTINCT Country AS CName FROM Chinook.dbo.Customer
	UNION
SELECT DISTINCT Country AS CName FROM Chinook.dbo.Employee
	UNION
SELECT DISTINCT BillingCountry AS CName FROM Chinook.dbo.Invoice


-- Collect cities among tables
INSERT INTO City(CiName, CountryId)
SELECT coll.CiName, c.Id AS CountryId FROM
	(SELECT DISTINCT City AS CiName, Country FROM Chinook.dbo.Customer
		UNION
	SELECT DISTINCT City AS CiName, Country FROM Chinook.dbo.Employee
		UNION
	SELECT DISTINCT BillingCity AS CiName, BillingCountry AS Country FROM Chinook.dbo.Invoice) AS coll JOIN Country AS c ON
	coll.Country = c.CName


-- Generate Random value when Postalcode is NULL

UPDATE Chinook.dbo.Customer
SET PostalCode = (SELECT SUBSTRING(CONVERT(varchar(40), NEWID()),0,9))
WHERE PostalCode IS NULL

UPDATE Chinook.dbo.Employee
SET PostalCode = (SELECT SUBSTRING(CONVERT(varchar(40), NEWID()),0,9))
WHERE PostalCode IS NULL

UPDATE Chinook.dbo.Invoice
SET BillingPostalCode = (SELECT SUBSTRING(CONVERT(varchar(40), NEWID()),0,9))
WHERE BillingPostalCode IS NULL

-- Building up address table

INSERT INTO Adress(PostalCode, Addr, CityId)
SELECT coll.PostalCode, coll.Addr, c.Id AS CityId FROM
	(SELECT DISTINCT City AS CiName, Address AS Addr, PostalCode FROM Chinook.dbo.Customer
		UNION
	SELECT DISTINCT City AS CiName, Address AS Addr, PostalCode FROM Chinook.dbo.Employee
		UNION
	SELECT DISTINCT BillingCity AS CiName, BillingAddress AS Addr, BillingPostalCode AS PostalCode FROM Chinook.dbo.Invoice) AS coll
	JOIN City AS c ON
	coll.CiName = c.CiName

INSERT INTO BI_source.dbo.Customer(FirstName,LastName,Phone,Fax,Email)
SELECT FirstName,LastName,Phone,Fax,Email FROM Chinook.dbo.Customer


IF (OBJECT_ID('CreateConcert', 'P') IS NOT NULL) 
	DROP PROCEDURE CreateConcert 
GO

CREATE PROCEDURE CreateConcert
AS 
BEGIN 
declare @maxArtistId int;
declare @concertDB int;
declare @artistId int;
declare @postalCode varchar(200);
declare @addressNumber int;
declare @rowNum int;
declare @date date;
set @concertDB=0;

SELECT @addressNumber=COUNT(*) FROM Adress
SELECT @maxArtistId=Max(Id) FROM Artist
WHILE @concertDB<400
BEGIN
SELECT @rowNum=rand() * @addressNumber+ 1;
SELECT @postalCode=PostalCode FROM (
      SELECT ROW_NUMBER() OVER (ORDER BY Addr ASC) AS RowNumber,
      *
      FROM Adress
 ) AS code
WHERE RowNumber = @rowNum;

SELECT @artistId=rand() * @maxArtistId + 1;
SELECT @date= DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 3650), '2000-01-01')

INSERT INTO Concert(PostalCode,CDate,ArtistId)
SELECT @postalCode,@date,@artistId
 
 SET @concertDB=@concertDB+1;

END

END
GO

EXECUTE CreateConcert 
--DROP PROCEDURE CreateConcert
GO


-- Put some Random value when Composer is NULL

UPDATE Chinook.dbo.Track
SET Composer = N'Gyozike'
WHERE Composer IS NULL

--Row number random to be done 

INSERT INTO Track(TName,AlbumId,MediaTypeId,GenreId,Composer,Miliseconds,Bytes,UnitPrice)
SELECT coll.Name AS TName, alb.Id AS AlbumId, mt.Id AS MediaTypeId, ge.Id AS GenreId, coll.Composer, coll.Milliseconds,
	coll.Bytes, coll.UnitPrice FROM(
	SELECT orig.Name, a.Title AS album, m.Name AS mediaType, g.Name AS Genre,orig.Composer, 
			orig.Bytes, orig.Milliseconds ,orig.UnitPrice FROM Chinook.dbo.Track AS orig
	JOIN Chinook.dbo.Album a ON a.AlbumId = orig.AlbumId
	JOIN Chinook.dbo.MediaType m ON m.MediaTypeId = orig.MediaTypeId
	JOIN Chinook.dbo.Genre g ON g.GenreId = orig.GenreId) AS coll
JOIN Album alb ON alb.Title = coll.album
JOIN MediaType mt ON mt.MName = coll.mediaType
JOIN Genre ge ON ge.GName = coll.Genre


INSERT INTO Invoice(CustomerId,InvoiceDate, PostalCode, Total)
SELECT cust.Id AS CustomerId, coll.InvoiceDate, coll.PostalCode, coll.Total FROM 
	(SELECT c.FirstName, c.LastName, c.Email, orig.InvoiceDate, orig.BillingPostalCode AS PostalCode, orig.Total
	FROM Chinook.dbo.Invoice AS orig
	JOIN Chinook.dbo.Customer c ON c.CustomerId = orig.CustomerId) AS coll
JOIN Customer cust ON cust.FirstName = coll.FirstName AND cust.LastName = coll.LastName AND cust.Email = coll.Email


INSERT INTO InvoiceLine(InvoiceId, TrackId, UnitPrice, Quantity)
SELECT inv.Id AS InvoiceId, letsee.TrackId, letsee.UnitPrice, letsee.Quantity FROM
	(SELECT almost.BillingPostalCode, c.FirstName, c.LastName, c.Email, almost.InvoiceDate, almost.TrackId, almost.UnitPrice, almost.Quantity FROM
		(SELECT coll.BillingPostalCode, coll.CustomerId, coll.InvoiceDate, tr.Id AS TrackId, coll.UnitPrice, coll.Quantity FROM
			(SELECT i.BillingPostalCode, i.CustomerId, i.InvoiceDate, 
					t.Name, t.Composer, t.Milliseconds, t.UnitPrice AS trackUnitPrice,
					orig.UnitPrice, orig.Quantity FROM Chinook.dbo.InvoiceLine AS orig
			JOIN Chinook.dbo.Invoice i ON i.InvoiceId = orig.InvoiceId
			JOIN Chinook.dbo.Track t ON t.TrackId = orig.TrackId) AS coll
		JOIN Track tr ON tr.TName = coll.Name AND tr.Composer = coll.Composer 
							AND tr.Miliseconds = coll.Milliseconds AND tr.UnitPrice = coll.trackUnitPrice) AS almost
	JOIN Chinook.dbo.Customer c ON c.CustomerId = almost.CustomerId) AS letsee
JOIN Customer cust ON cust.FirstName = letsee.FirstName AND cust.LastName = letsee.LastName AND cust.Email = letsee.Email
JOIN Invoice inv ON inv.PostalCode = letsee.BillingPostalCode AND inv.CustomerId = cust.Id AND inv.InvoiceDate = letsee.InvoiceDate


IF (OBJECT_ID('GenerateTicket', 'P') IS NOT NULL) 
	DROP PROCEDURE GenerateTicket 
GO

CREATE PROCEDURE GenerateTicket
AS 
BEGIN 
	declare @date date;
	declare @postalCode nvarchar(20);

	declare @nrOfConcert int;
	declare @nrOfCustomer int;
	declare @nrOfAddresses int;
	declare @row_Concert int;
	declare @row_Customer int;
	declare @row_Address int;

	declare @iterator int;
	declare @price int;

	declare @invoiceID int;
	declare @concertID int;
	declare @customerID int;

	SET @iterator = 0;

	SET @nrOfConcert = (SELECT COUNT(*) FROM Concert);
	SET @nrOfConcert = @nrOfConcert - 1;

	SET @nrOfCustomer = (SELECT COUNT(*) FROM Customer);
	SET @nrOfCustomer = @nrOfCustomer - 1;

	SET @nrOfAddresses = (SELECT COUNT(*) FROM Adress);
	SET @nrOfAddresses = @nrOfAddresses - 1;

	WHILE @iterator < 4000
	BEGIN
		SELECT @row_Concert = rand() * @nrOfConcert + 1;
		SELECT @row_Customer = rand() * @nrOfCustomer + 1;
		SELECT @row_Address = rand() * @nrOfAddresses + 1;

		SELECT @price = rand() * 258;
		SELECT @date= DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 3650), '2000-01-01');

		SET @concertID = (SELECT Id FROM
							(SELECT Id, ROW_NUMBER() OVER (ORDER BY Id ASC) AS rownumber
							  FROM Concert) AS foo
						  WHERE rownumber = @row_Concert);

		SET @customerID = (SELECT Id FROM
							(SELECT Id, ROW_NUMBER() OVER (ORDER BY Id ASC) AS rownumber
							  FROM Customer) AS foo
						  WHERE rownumber = @row_Customer);

		SET @postalCode = (SELECT PostalCode FROM
							(SELECT PostalCode, ROW_NUMBER() OVER (ORDER BY PostalCode ASC) AS rownumber
							  FROM Adress) AS foo
						  WHERE rownumber = @row_Address);


		INSERT INTO Invoice(CustomerId, InvoiceDate, PostalCode, Total)
		VALUES (@customerID, @date, @postalCode, @price)
 
		SET @invoiceID = (SELECT TOP 1 Id FROM Invoice ORDER BY Id DESC);

		INSERT INTO Tickets(ConcertId, Price, InvoiceId)
		VALUES (@concertID, @price, @invoiceID)

		SET @iterator = @iterator+1;
	END
END
GO

EXEC GenerateTicket
GO