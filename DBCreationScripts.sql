CREATE TABLE Artist
(
Id int PRIMARY KEY,
AName varchar(200),
); 

CREATE TABLE Country
(
Id int PRIMARY KEY,
CName varchar(200)
);

CREATE TABLE City
(
Id int PRIMARY KEY,
CiName varchar(200)
);

CREATE TABLE Album(
Id int PRIMARY KEY,
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
Id int PRIMARY KEY,
PostalCode int REFERENCES Adress(PostalCode),
CDate date,
ArtistId int REFERENCES Artist(Id)
)

CREATE TABLE MediaType(
Id int PRIMARY KEY,
MName varchar(200),
)

CREATE TABLE Genre(
Id int PRIMARY KEY,
GName varchar(200)
)

CREATE TABLE Track(
Id int PRIMARY KEY,
TName varchar(200),
AlbumId int REFERENCES Album(Id),
MediaTypeId int REFERENCES MediaType(Id),
GenreId int REFERENCES Genre(Id),
Composer varchar(200),
Miliseconds int,
Bytes int,
UnitPrie int
)



