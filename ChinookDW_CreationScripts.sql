CREATE DATABASE Chinook_DW;
GO

USE Chinook_DW;
GO

CREATE TABLE DIM_Location(
Loc_SK int PRIMARY KEY IDENTITY(1,1),
Addr varchar(200),
City varchar(200),
Country varchar(200),
PostalCode integer
)

CREATE TABLE DIM_Artist(
Artist_SK int PRIMARY KEY IDENTITY(1,1),
AName varchar(200)
)

CREATE TABLE DIM_Date(
Date_SK int PRIMARY KEY IDENTITY(1,1),
DYear int,
DMonth int,
DDay int
--quarter??
)

CREATE TABLE FACT_Concert(
Concert_SK int PRIMARY KEY IDENTITY(1,1),
Artist_SK int REFERENCES DIM_Artist(Artist_SK),
Location_SK int REFERENCES DIM_Location(Loc_SK),
Tickets int,
Total int
)

CREATE TABLE DIM_Address(
Address_SK int PRIMARY KEY IDENTITY(1,1),
Addr varchar(200),
City varchar(200),
Country varchar(200),
FirstName varchar(50),
LastName varchar(50),
Email varchar(40)
)

CREATE TABLE DIM_Song(
Song_SK int PRIMARY KEY IDENTITY(1,1),
TrackName varchar(200),
AlbumName varchar(200),
MediaTypeName varchar(200),
GenreName varchar(200),
Composer int,
Milliseconds int,
Bytes int
)

CREATE TABLE FACT_Invoice(
Invoice_SK int PRIMARY KEY IDENTITY(1,1),
Date_SK int REFERENCES DIM_Date(Date_SK),
Customer varchar(100), --??
Address_SK int REFERENCES DIM_Address(Address_SK),
Song_SK int REFERENCES DIM_Song(Song_SK),
TotalPrice int,
Artist_SK int REFERENCES DIM_Artist(Artist_SK)
)