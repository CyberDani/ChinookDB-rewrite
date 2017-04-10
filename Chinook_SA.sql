--DROP DATABASE Chinook_SA
--CREATE DATABASE Chinook_SA
USE Chinook_SA

CREATE TABLE Country(
ID INT PRIMARY KEY IDENTITY(1,1),
CountryID nvarchar(512),
cName nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE City(
ID INT PRIMARY KEY IDENTITY(1,1),
CityID nvarchar(512),
ciName nvarchar(512),
countryId nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Adress(
ID INT PRIMARY KEY IDENTITY(1,1),
AdressID nvarchar(512),
addr nvarchar(512),
cityId nvarchar(512),
postalCode nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Artist(
ID INT PRIMARY KEY IDENTITY(1,1),
ArtistID nvarchar(512),
aName nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Album(
ID INT PRIMARY KEY IDENTITY(1,1),
AlbumID nvarchar(512),
title nvarchar(512),
artistId nvarchar(512),
releaseDate nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Concert(
ID INT PRIMARY KEY IDENTITY(1,1),
ConcertID nvarchar(512),
postalCode nvarchar(512),
cDate  nvarchar(512),
artistId nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Customer(
ID INT PRIMARY KEY IDENTITY(1,1),
CustomerID nvarchar(512),
firstName nvarchar(512),
lastName nvarchar(512),
phone nvarchar(512),
fax nvarchar(512),
email nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Genre(
ID INT PRIMARY KEY IDENTITY(1,1),
GenreID nvarchar(512),
gName nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Invoice(
ID INT PRIMARY KEY IDENTITY(1,1),
InvoiceID nvarchar(512),
customerId nvarchar(512),
invoiceDate nvarchar(512),
postalCode nvarchar(512),
total nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE InvoiceLine(
ID INT PRIMARY KEY IDENTITY(1,1),
InvoiceLineID nvarchar(512),
invoiceId nvarchar(512),
trackId nvarchar(512),
unitPrice nvarchar(512),
quantity  nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE MediaType(
ID INT PRIMARY KEY IDENTITY(1,1),
MTID nvarchar(512),
mName nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Tickets(
ID INT PRIMARY KEY IDENTITY(1,1),
TicketsID nvarchar(512),
concertId nvarchar(512),
price nvarchar(512),
invoiceId nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Track(
ID INT PRIMARY KEY IDENTITY(1,1),
TrackID nvarchar(512),
tName nvarchar(512),
albumId nvarchar(512),
mediaTypeId nvarchar(512),
genreId nvarchar(512),
composer nvarchar(512),
miliseconds nvarchar(512),
bytes nvarchar(512),
unitPrice nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)