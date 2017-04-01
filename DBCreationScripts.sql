-- Uj adatbazis letrehozasa

CREATE DATABASE BI_source
use BI_source

-- Tablak letrehozasa

CREATE TABLE Artist
(
Id int PRIMARY KEY IDENTITY(1,1),
AName varchar(200),
); 

CREATE TABLE Country
(
Id int PRIMARY KEY IDENTITY(1,1),
CName varchar(200)
);

CREATE TABLE City
(
Id int PRIMARY KEY IDENTITY(1,1),
CiName varchar(200)
);

CREATE TABLE Album(
Id int PRIMARY KEY IDENTITY(1,1),
Title varchar(200),
ArtistId int REFERENCES Artist(Id),
ReleaseDate date
)

CREATE TABLE Adress(
PostalCode int PRIMARY KEY,
Addr varchar(200),
CityId int REFERENCES City(Id),
CountryId int REFERENCES Country(Id)
)

CREATE TABLE Concert(
Id int PRIMARY KEY IDENTITY(1,1),
PostalCode int REFERENCES Adress(PostalCode),
CDate date,
ArtistId int REFERENCES Artist(Id)
)

CREATE TABLE MediaType(
Id int PRIMARY KEY IDENTITY(1,1),
MName varchar(200),
)

CREATE TABLE Genre(
Id int PRIMARY KEY IDENTITY(1,1),
GName varchar(200)
)

CREATE TABLE Track(
Id int PRIMARY KEY IDENTITY(1,1),
TName varchar(200),
AlbumId int REFERENCES Album(Id),
MediaTypeId int REFERENCES MediaType(Id),
GenreId int REFERENCES Genre(Id),
Composer varchar(200),
Miliseconds int,
Bytes int,
UnitPrie int
)

CREATE TABLE Customer(
Id int PRIMARY KEY IDENTITY(1,1),
FirstName varchar(50),
LastName varchar(50),
Phone varchar(25),
Fax varchar(25),
Email varchar(40)
)

CREATE TABLE Invoice(
Id int PRIMARY KEY IDENTITY(1,1),
CustomerId int REFERENCES Customer(Id),
InvoiceDate date,
PostalCode int REFERENCES Adress(PostalCode),
Total int
)

CREATE TABLE InvoiceLine(
Id int PRIMARY KEY IDENTITY(1,1),
InvoiceId int REFERENCES Invoice(Id),
TrackId int REFERENCES Track(Id),
UnitPrice int,
Quantity int
)

CREATE TABLE Tickets(
Id int PRIMARY KEY IDENTITY(1,1),
ConcertId int REFERENCES Concert(Id),
Price int,
InvoiceId int REFERENCES Invoice(Id)
)