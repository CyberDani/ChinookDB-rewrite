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

EXECUTE CreateConcert 
--DROP PROCEDURE CreateConcert

--Row number random to be done 

INSERT INTO Track(TName,AlbumId,MediaTypeId,GenreId,Composer,Miliseconds,Bytes,UnitPrie)
SELECT Name,AlbumId,MediaTypeId,GenreId,Composer,Milliseconds,Bytes,UnitPrice  FROM Chinook.dbo.Track 
