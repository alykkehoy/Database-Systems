----------------------------------------------------------------------------------------
-- Magic the Gathering
-- Organized Play
-- by Anders Lykkehoy
----------------------------------------------------------------------------------------
DROP TABLE IF EXISTS PlaysIn;
DROP TABLE IF EXISTS Match;
DROP TABLE IF EXISTS GameType;
DROP TABLE IF EXISTS Tournament;
DROP TABLE IF EXISTS Tier;
DROP TABLE IF EXISTS Judge;
DROP TABLE IF EXISTS JudgeLevel;
DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS BannedPeople;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS DeckCards;
DROP TABLE IF EXISTS Card;
DROP TABLE IF EXISTS Set;

--
-- The table of Sets.
--
CREATE TABLE Set (
    id    integer not null,
    name  text    not null,
    year  integer not null,
  primary key (id)
);

--
-- The table of Cards.
--
CREATE TABLE Card (
    id    INTEGER NOT NULL,
    name  text    NOT NULL,
    setID INTEGER NOT NULL REFERENCES Card(id),
  PRIMARY KEY (id)
);

--
-- The table of Decks.
--
CREATE TABLE DeckCards (
    id        INTEGER NOT NULL,
    cardID    INTEGER NOT NULL REFERENCES Card(id),
    instances INTEGER NOT NULL DEFAULT 1,
  PRIMARY KEY (id)
);

--
-- The table of judge levels.
--
CREATE TABLE JudgeLevel (
    level      INTEGER NOT NULL,
    name       text    NOT NULL,
    yearsValid INTEGER NOT NULL,
  PRIMARY KEY (level)
);

--
-- The table of game types.
--
CREATE TABLE GameType (
    id   INTEGER NOT NULL,
    name text    NOT NULL,
  PRIMARY KEY (id)
);

--
-- The table of tournament tiers.
--
CREATE TABLE Tier (
    id     INTEGER NOT NULL,
    name   text    NOT NULL,
    weight INTEGER NOT NULL,
  PRIMARY KEY (id)
);

--
-- The table of tournaments.
--
CREATE TABLE Tournament (
    id       INTEGER NOT NULL,
    name     text    NOT NULL,
    location text    NOT NULL,
    teirID   integer NOT NULL REFERENCES Tier(id),
  PRIMARY KEY (id)
);

--
-- The table of people.
--
CREATE TABLE Person (
    id     INTEGER NOT NULL,
    fname  text    NOT NULL,
    lname  text    NOT NULL,
    bday   INTEGER NOT NULL,
    bmonth INTEGER NOT NULL,
    byear  INTEGER NOT NULL,
  PRIMARY KEY (id)
);

--
-- The table of judges.
--
CREATE TABLE Judge (
    personID INTEGER NOT NULL REFERENCES Person(id),
    level    INTEGER NOT NULL REFERENCES JudgeLevel(level),
    certYear INTEGER NOT NULL,
  PRIMARY KEY (personID)
);

--
-- The table of players.
--
CREATE TABLE Player (
    personID INTEGER NOT NULL REFERENCES Person(id),
    favCard  INTEGER NOT NULL REFERENCES Card(id),
    points   INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (personID)
);

--
-- The table of matches.
--
CREATE TABLE Match (
    id           INTEGER NOT NULL,
    tournamentID INTEGER NOT NULL REFERENCES Tournament(id),
    gameType     INTEGER NOT NULL REFERENCES GameType(id),
    judgeID      INTEGER NOT NULL REFERENCES Judge(personID),
  PRIMARY KEY (id)
);

--
-- The table of players and their played matches.
--
CREATE TABLE PlaysIn (
    matchID  INTEGER NOT NULL REFERENCES Match(id),
    playerID INTEGER NOT NULL REFERENCES Player(personID),
    deckID   INTEGER NOT NULL REFERENCES DeckCards(id),
    side     integer NOT NULL,
    result   text    NOT NULL,
  PRIMARY KEY (matchID, playerID)
);

CREATE TABLE BannedPeople (
  personID     INTEGER NOT NULL REFERENCES Person(id),
  reason       text,
  startDate    text    NOT NULL,
  legth_months INTEGER NOT NULL,
  PRIMARY KEY (personID)
);
--
-- insert into Courses(num, name, credits)
-- values (499, 'CS/ITS Capping', 3 );
--
-- insert into Courses(num, name, credits)
-- values (308, 'Database Systems', 4 );
--
-- insert into Courses(num, name, credits)
-- values (221, 'Software Development Two', 4 );
--
-- insert into Courses(num, name, credits)
-- values (220, 'Software Development One', 4 );
--
-- insert into Courses(num, name, credits)
-- values (120, 'Introduction to Programming', 4);
--
-- select *
-- from courses
-- order by num ASC;
--
--
-- --
-- -- Courses and their prerequisites
-- --
-- create table Prerequisites (
--     courseNum integer not null references Courses(num),
--     preReqNum integer not null references Courses(num),
--   primary key (courseNum, preReqNum)
-- );
--
-- insert into Prerequisites(courseNum, preReqNum)
-- values (499, 308);
--
-- insert into Prerequisites(courseNum, preReqNum)
-- values (499, 221);
--
-- insert into Prerequisites(courseNum, preReqNum)
-- values (308, 120);
--
-- insert into Prerequisites(courseNum, preReqNum)
-- values (221, 220);
--
-- insert into Prerequisites(courseNum, preReqNum)
-- values (220, 120);
--
-- select *
-- from Prerequisites
-- order by courseNum DESC;
--
--
-- --
-- -- An example stored procedure ("function")
-- --
-- create or replace function get_courses_by_credits(int, REFCURSOR) returns refcursor as
-- $$
-- declare
--    num_credits int       := $1;
--    resultset   REFCURSOR := $2;
-- begin
--    open resultset for
--       select num, name, credits
--       from   courses
--        where  credits >= num_credits;
--    return resultset;
-- end;
-- $$
-- language plpgsql;
--
-- select get_courses_by_credits(0, 'results');
-- Fetch all from results;
