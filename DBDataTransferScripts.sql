/*******************************************************************************
  Feltoltes adatokkal
********************************************************************************/

use BI_source

INSERT INTO Artist(AName)
SELECT DISTINCT * FROM Chinook.dbo.Artist