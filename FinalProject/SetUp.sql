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
    id    SERIAL,
    name  text    not null,
    year  integer not null,
  primary key (id)
);

--
-- The table of Cards.
--
CREATE TABLE Card (
    id    SERIAL,
    name  text    NOT NULL,
    setID INTEGER NOT NULL REFERENCES Card(id),
  PRIMARY KEY (id)
);

--
-- The table of Decks.
--
CREATE TABLE DeckCards (
    id        SERIAL,
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
    id   SERIAL,
    name text    NOT NULL,
  PRIMARY KEY (id)
);

--
-- The table of tournament tiers.
--
CREATE TABLE Tier (
    id     SERIAL,
    name   text    NOT NULL,
    weight INTEGER NOT NULL,
  PRIMARY KEY (id)
);

--
-- The table of tournaments.
--
CREATE TABLE Tournament (
    id       SERIAL,
    name     text    NOT NULL,
    location text    NOT NULL,
    teirID   integer NOT NULL REFERENCES Tier(id),
  PRIMARY KEY (id)
);

--
-- The table of people.
--
CREATE TABLE Person (
    id     SERIAL,
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
    id           SERIAL,
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

--
-- The table of banned people.
--
CREATE TABLE BannedPeople (
  personID     INTEGER NOT NULL REFERENCES Person(id),
  reason       text,
  startDate    text    NOT NULL,
  legth_months INTEGER NOT NULL,
  PRIMARY KEY (personID)
);