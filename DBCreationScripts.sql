CREATE TABLE Artist
(
Id int PRIMARY KEY,
Name varchar(200),
); 

CREATE TABLE Country
(
Id int PRIMARY KEY,
Name varchar(200)
);

CREATE TABLE City
(
Id int PRIMARY KEY,
Name varchar(200)
);

CREATE TABLE Album(
Id int PRIMARY KEY,
Title varchar(200),
ArtistId int REFERENCES Artist(Id),
ReleaseDate date
)

CREATE TABLE Adress(
PostalCode int PRIMARY KEY,
Address varchar(200),
CityId int REFERENCES City(Id),
CountryId int REFERENCES Country(Id)
)