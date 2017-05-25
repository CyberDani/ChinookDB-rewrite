/*CREATE DATABASE Chinook_DM*/
USE Chinook_DM
CREATE TABLE DimArtist(
SK_Artist INT PRIMARY KEY IDENTITY(1,1),
BK_Artist VARCHAR(10),
AName VARCHAR(200),
DATEFROM DATETIME, 
ISVALID BIT
)

CREATE TABLE DimLocation(
SK_Location INT PRIMARY KEY IDENTITY(1,1),
BK_Location VARCHAR(10),
Addr VARCHAR(200),
City VARCHAR(200),
Country VARCHAR(200),
PostalCode VARCHAR(200),
DATEFROM DATETIME, 
ISVALID BIT
)

CREATE TABLE DimDate(
SK_Date int PRIMARY KEY,
BK_Date VARCHAR(10),
Datum DATETIME,
DateMonth VARCHAR(10), 
DateYear VARCHAR(10),
DName VARCHAR(40),
DateQuarter VARCHAR(10),
DATEFROM DATETIME, 
ISVALID BIT
)

CREATE TABLE FactConcert(
SK_Date int REFERENCES DimDate(SK_Date),
SK_Artist INT REFERENCES DimArtist(SK_Artist),
TicketNr INT,
TotalPrice FLOAT
)

CREATE TABLE DimCustomerAddress(
SK_CustomerAddress int PRIMARY KEY,
BK_CustomerAddress VARCHAR(10),
Address VARCHAR(200),
City VARCHAR(200),
Country VARCHAR(200),
FirstName VARCHAR(50),
LastName VARCHAR(50),
Email VARCHAR(40),
DATEFROM DATETIME, 
ISVALID BIT
)

CREATE TABLE DimSong(
SK_Song INT PRIMARY KEY IDENTITY(1,1),
BK_Song INT,
TrackName VARCHAR(200),
AlbumName VARCHAR(200),
MediaTypeName VARCHAR(200),
GenreName VARCHAR(200),
Composer  VARCHAR(200),
Milliseconds INT,
Bytes INT,
DATEFROM DATETIME, 
ISVALID BIT
)

CREATE TABLE FactInvoice(
SK_Date INT REFERENCES DimDate(SK_Date),
SK_AddrCust INT REFERENCES DimCustomerAddress(SK_CustomerAddress),
SK_Song INT REFERENCES DimSong(SK_Song),
SK_Artist INT REFERENCES DimArtist(SK_Artist),
TotalPrice FLOAT
)
