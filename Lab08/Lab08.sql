DROP TABLE IF EXISTS Credit;
DROP TABLE IF EXISTS Movie;
DROP TABLE IF EXISTS Director;
DROP TABLE IF EXISTS Actor;
DROP TABLE IF EXISTS Person;

CREATE TABLE public.Movie
(
  ID INT PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  "release year" INTEGER,
  "MPAA number" INTEGER,
  "domestic sales" MONEY,
  "foreign sales" MONEY,
  "physical sales" MONEY
);

CREATE TABLE public.Person
(
    ID INT PRIMARY KEY,
    "first name" TEXT NOT NULL,
    "last name" TEXT NOT NULL,
    address TEXT,
    spouse TEXT
);

CREATE TABLE public.Director(
  PersonID INT PRIMARY KEY REFERENCES Person(ID) NOT NULL,
  school TEXT,
  "dg date" TEXT,
  "lense maker" TEXT
);

CREATE TABLE public.Actor(
  PersonID INT PRIMARY KEY REFERENCES Person(ID) NOT NULL,
  "birth day" INT,
  "birth month" INT,
  "birth year" INT,
  "hair color" TEXT,
  "eye color" TEXT,
  "height(in)" INT,
  "weight (lbs)" INT,
  "favorit color" text,
  "sag date" text
);

CREATE TABLE public.Credit(
  PersonID INT REFERENCES Person(ID) NOT NULL,
  MovieID INT REFERENCES Movie(ID) NOT NULL,
  roll TEXT NOT NULL CHECK (roll IN ('Director', 'Actor')),

  PRIMARY KEY (PersonID, MovieID, roll)
);

-- query to show all the directors with whom actor “Roger Moore” has worked
SELECT person."first name", person."last name"
FROM credit INNER JOIN person ON credit.PersonID = person.ID
WHERE roll = 'Director'
AND MovieID IN (
  SELECT MovieID
  FROM credit
    INNER JOIN person ON credit.PersonID = person.ID
  WHERE "first name" = 'Roger' AND "last name" = 'Moore'
);