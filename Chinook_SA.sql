CREATE DATABASE Chinook_SA
USE Chinook_SA

CREATE TABLE Country(
ID int PRIMARY KEY IDENTITY(1,1),
cName nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE City(
ID int PRIMARY KEY IDENTITY(1,1),
ciName nvarchar(512),
countryId nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Adress(
ID int PRIMARY KEY IDENTITY(1,1),
addr nvarchar(512),
cityId nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Artist(
ID int PRIMARY KEY IDENTITY(1,1),
aName nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Album(
ID int PRIMARY KEY IDENTITY(1,1),
title nvarchar(512),
artistId nvarchar(512),
releaseDate nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Concert(
ID int PRIMARY KEY IDENTITY(1,1),
postalCode nvarchar(512),
cDate  nvarchar(512),
artistId nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Customer(
ID int PRIMARY KEY IDENTITY(1,1),
firstName nvarchar(512),
lastName nvarchar(512),
phone nvarchar(512),
fax nvarchar(512),
email nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Genre(
ID int PRIMARY KEY IDENTITY(1,1),
gName nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Invoice(
ID int PRIMARY KEY IDENTITY(1,1),
customerId nvarchar(512),
invoiceDate nvarchar(512),
postalCode nvarchar(512),
total nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE InvoiceLine(
ID int PRIMARY KEY IDENTITY(1,1),
invoiceId nvarchar(512),
trackId nvarchar(512),
unitPrice nvarchar(512),
quantity  nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE MediaType(
ID int PRIMARY KEY IDENTITY(1,1),
mName nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Tickets(
ID int PRIMARY KEY IDENTITY(1,1),
concertId nvarchar(512),
price nvarchar(512),
invoiceId nvarchar(512),
EXECUTION_INSTANCE_GUID nvarchar(38) not null,
LOAD_DATE datetime not null
)

CREATE TABLE Track(
ID int PRIMARY KEY IDENTITY(1,1),
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