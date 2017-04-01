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

