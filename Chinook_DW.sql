/*******************************************************************************
   Drop database if it exists
********************************************************************************/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'Chinook_DW')
BEGIN
	ALTER DATABASE Chinook_DW SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE Chinook_DW SET ONLINE;
	DROP DATABASE Chinook_DW;
END

GO

/*******************************************************************************
   Create database
********************************************************************************/
CREATE DATABASE Chinook_DW;
GO

USE Chinook_DW;
GO

/*******************************************************************************
   Tablak letrehozasa
********************************************************************************/

--  Address
--~=============/
CREATE TABLE HubAdress(
H_Adr_SQN INT PRIMARY KEY,
H_Adr_BK VARCHAR(10),
H_Adr_LDTS DATETIME,
H_Adr_RSRC VARCHAR(30)
)

CREATE TABLE SatAdress(
H_Adr_Hub_SQN INT NOT NULL REFERENCES HubAdress(H_Adr_SQN),
S_Adr_LDTS DATETIME,
S_Adr_RSRC VARCHAR(30),
addr VARCHAR(200),
postalCode VARCHAR(200)
)

--  City
--~=============/
CREATE TABLE HubCity(
H_City_SQN INT PRIMARY KEY,
H_City_BK VARCHAR(10),
H_City_LDTS DATETIME,
H_City_RSRC VARCHAR(30)
)

CREATE TABLE SatCity(
H_City_Hub_SQN INT NOT NULL REFERENCES HubCity(H_City_SQN),
S_Adr_LDTS DATETIME,
S_Adr_RSRC VARCHAR(30),
ciName VARCHAR(200)
)

--  Country
--~=============/
CREATE TABLE HubCountry(
H_Country_SQN INT PRIMARY KEY,
H_Country_BK VARCHAR(10),
H_Country_LDTS DATETIME,
H_Country_RSRC VARCHAR(30)
)

CREATE TABLE SatCountry(
H_Country_SQN INT NOT NULL REFERENCES HubCountry(H_Country_SQN),
S_Adr_LDTS DATETIME,
S_Adr_RSRC VARCHAR(30),
CName VARCHAR(200)
)

-- Link ==> Adress + City + Country
CREATE TABLE LinkAdrCityCountry(
L_AdrCity_SQN INT PRIMARY KEY,
L_AdrCity_LDTS DATETIME,
L_AdrCity_RSRC VARCHAR(30),
H_Adr_SQN INT REFERENCES HubAdress(H_Adr_SQN),
H_City_SQN INT REFERENCES HubCity(H_City_SQN),
H_Country_SQN INT REFERENCES HubCountry(H_Country_SQN) 
)

--  Artist
--~=============/
CREATE TABLE HubArtist(
H_Artist_SQN INT PRIMARY KEY,
H_Artist_BK VARCHAR(10),
H_Artist_LDTS DATETIME,
H_Artist_RSRC VARCHAR(30)
)

CREATE TABLE SatArtist(
H_Artist_SQN INT NOT NULL REFERENCES HubArtist(H_Artist_SQN),
S_Artist_LDTS DATETIME,
S_Artist_RSRC VARCHAR(30),
AName VARCHAR(200)
)

--  Concert
--~=============/
CREATE TABLE HubConcert(
H_Concert_SQN INT PRIMARY KEY,
H_Concert_BK VARCHAR(10),
H_Concert_LDTS DATETIME,
H_Concert_RSRC VARCHAR(30)
)

CREATE TABLE SatConcert(
H_Concert_SQN INT NOT NULL REFERENCES HubConcert(H_Concert_SQN),
S_Concert_LDTS DATETIME,
S_Concert_RSRC VARCHAR(30),
CDate date,
postalCode varchar(20)
)

-- Link ==> Artist + Concert
CREATE TABLE ConcertArtLink(
L_ConcertArt_SQN INT PRIMARY KEY,
L_ConcertArt_LDTS DATETIME,
L_ConcertArt_RSRC VARCHAR(30),
H_Artist_SQN INT REFERENCES HubArtist(H_Artist_SQN),
H_Concert_SQN INT REFERENCES HubConcert(H_Concert_SQN) 
)

--  Invoice
--~=============/
CREATE TABLE HubInvoice(
H_Invoice_SQN INT PRIMARY KEY,
H_Invoice_BK VARCHAR(10),
H_Invoice_LDTS DATETIME,
H_Invoice_RSRC VARCHAR(30)
)

CREATE TABLE SatInvoice(
H_Invoice_SQN INT NOT NULL REFERENCES HubConcert(H_Concert_SQN),
S_Invoice_LDTS DATETIME,
S_Invoice_RSRC VARCHAR(30),
invoiceDate date,
postalCode varchar(20),
total integer
)

--  Customer
--~=============/
CREATE TABLE HubCustomer(
	H_Customer_SQN INT PRIMARY KEY,
	H_Customer_BK VARCHAR(10),
	H_Customer_LDTS DATETIME,
	H_Customer_RSRC VARCHAR(30)
)

CREATE TABLE SatCustomer(
	H_Customer_Hub_SQN INT NOT NULL REFERENCES HubCustomer(H_Customer_SQN),
	S_Customer_LDTS DATETIME,
	S_Customer_RSRC VARCHAR(30),
	FirstName varchar(50),
	LastName varchar(50),
	Phone varchar(25),
	Fax varchar(25),
	Email varchar(40)
)

-- Link ==> Invoice + Customer
CREATE TABLE LinkInvoiceCust(
	L_InvoiceCust_SQN INT PRIMARY KEY,
	L_InvoiceCust_LDTS DATETIME,
	L_InvoiceCust_RSRC VARCHAR(30),
	H_Invoice_SQN INT REFERENCES HubInvoice(H_Invoice_SQN),
	H_Customer_SQN INT REFERENCES HubCustomer(H_Customer_SQN) 
)

--  MediaType
--~=============/
CREATE TABLE HubMediaType(
	H_MedType_SQN INT PRIMARY KEY,
	H_MedType_BK VARCHAR(10),
	H_MedType_LDTS DATETIME,
	H_MedType_RSRC VARCHAR(30)
)

CREATE TABLE SatMediaType(
	H_MedType_Hub_SQN INT NOT NULL REFERENCES HubMediaType(H_MedType_SQN),
	S_MedType_LDTS DATETIME,
	S_MedType_RSRC VARCHAR(30),
	MTname VARCHAR(200)
)

--  Genre
--~=============/
CREATE TABLE HubGenre(
	H_Genre_SQN INT PRIMARY KEY,
	H_Genre_BK VARCHAR(10),
	H_Genre_LDTS DATETIME,
	H_Genre_RSRC VARCHAR(30)
)

CREATE TABLE SatGenre(
	H_Genre_Hub_SQN INT NOT NULL REFERENCES HubGenre(H_Genre_SQN),
	S_Genre_LDTS DATETIME,
	S_Genre_RSRC VARCHAR(30),
	Gname VARCHAR(200)
)

--  InvoiceLine
--~=============/
CREATE TABLE HubInvoiceLn(
	H_InvoiceLn_SQN INT PRIMARY KEY,
	H_InvoiceLn_BK VARCHAR(10),
	H_InvoiceLn_LDTS DATETIME,
	H_InvoiceLn_RSRC VARCHAR(30)
)

CREATE TABLE SatInvoiceLn(
	H_InvoiceLn_Hub_SQN INT NOT NULL REFERENCES HubInvoiceLn(H_InvoiceLn_SQN),
	S_InvoiceLn_LDTS DATETIME,
	S_InvoiceLn_RSRC VARCHAR(30),
	UnitPrice numeric(10,2),
	Quantity int
)

--  Track
--~=============/
CREATE TABLE HubTrack(
	H_Track_SQN INT PRIMARY KEY,
	H_Track_BK VARCHAR(10),
	H_Track_LDTS DATETIME,
	H_Track_RSRC VARCHAR(30)
)

CREATE TABLE SatTrack(
	H_Track_Hub_SQN INT NOT NULL REFERENCES HubTrack(H_Track_SQN),
	S_Track_LDTS DATETIME,
	S_Track_RSRC VARCHAR(30),
	TName varchar(200),
	Composer varchar(200),
	Miliseconds int,
	Bytes int,
	UnitPrice numeric(10,2)
)

-- Link ==> InvoiceLine + Track + Invoice
CREATE TABLE LinkInvoiceLn(
	L_InvoiceLn_SQN INT PRIMARY KEY,
	L_InvoiceLn_LDTS DATETIME,
	L_InvoiceLn_RSRC VARCHAR(30),
	H_InvoiceLn_SQN int REFERENCES HubInvoiceLn(H_InvoiceLn_SQN),
	H_Invoice_SQN int REFERENCES HubInvoice(H_Invoice_SQN),
	H_Track_SQN int REFERENCES HubTrack(H_Track_SQN),
)

--  Album
--~=============/
CREATE TABLE HubAlbum(
	H_Album_SQN INT PRIMARY KEY,
	H_Album_BK VARCHAR(10),
	H_Album_LDTS DATETIME,
	H_Album_RSRC VARCHAR(30)
)

CREATE TABLE SatAlbum(
	H_Album_Hub_SQN INT NOT NULL REFERENCES HubAlbum(H_Album_SQN),
	S_Album_LDTS DATETIME,
	S_Album_RSRC VARCHAR(30),
	Title varchar(200),
	ReleaseDate date
)

-- Link ==> Track + MediaType + Genre + Album
CREATE TABLE LinkTrack(
	L_Track_SQN INT PRIMARY KEY,
	L_Track_LDTS DATETIME,
	L_Track_RSRC VARCHAR(30),
	H_Track_SQN int REFERENCES HubTrack(H_Track_SQN),
	H_Album_SQN int REFERENCES HubAlbum(H_Album_SQN),
	H_MedType_SQN int REFERENCES HubMediaType(H_MedType_SQN),
	H_Genre_SQN int REFERENCES HubGenre(H_Genre_SQN),
)

-- Link ==> Album + Artist
CREATE TABLE LinkAlbum(
	L_Album_SQN INT PRIMARY KEY,
	L_Album_LDTS DATETIME,
	L_Album_RSRC VARCHAR(30),
	H_Album_SQN int REFERENCES HubAlbum(H_Album_SQN),
	H_Artist_SQN int REFERENCES HubArtist(H_Artist_SQN),
)

--  Tickets
--~=============/
CREATE TABLE HubTickets(
	H_Tickets_SQN INT PRIMARY KEY,
	H_Tickets_BK VARCHAR(10),
	H_Tickets_LDTS DATETIME,
	H_Tickets_RSRC VARCHAR(30)
)

CREATE TABLE SatTickets(
	H_Tickets_Hub_SQN INT NOT NULL REFERENCES HubTickets(H_Tickets_SQN),
	S_Tickets_LDTS DATETIME,
	S_Tickets_RSRC VARCHAR(30),
	Price int
)

-- Link ==> Tickets + Invoice
CREATE TABLE LinkTickets(
	L_Tickets_SQN INT PRIMARY KEY,
	L_Tickets_LDTS DATETIME,
	L_Tickets_RSRC VARCHAR(30),
	H_Tickets_SQN int REFERENCES HubTickets(H_Tickets_SQN),
	H_Invoice_SQN int REFERENCES HubInvoice(H_Invoice_SQN),
)

-- SSIS error Handling : new database+ table


--DROP DATABASE Chinook_CONFIG

CREATE DATABASE Chinook_CONFIG;
GO

USE Chinook_CONFIG;
GO

CREATE TABLE SSIS_PACKAGE_ERROR(
EXECUTION_INSTANCE_GUID NVARCHAR(38) NOT NULL,
BUSINESS_KEY NVARCHAR(512) NOT NULL,
COMPONENT NVARCHAR(64) NOT NULL,
PHASE NVARCHAR(64) NOT NULL,
ERROR_CODE INT NOT NULL,
ERROR_COLUMN NVARCHAR(50) NOT NULL
)
