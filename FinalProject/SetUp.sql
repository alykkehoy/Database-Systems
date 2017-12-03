----------------------------------------------------------------------------------------
-- Magic the Gathering:
-- Organized Play
-- by Anders Lykkehoy
----------------------------------------------------------------------------------------


-- drop all views
DROP VIEW IF EXISTS fullMatchView;
DROP VIEW IF EXISTS bannedPeopleInfo;

-- drop all tables
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
DROP TABLE IF EXISTS DeckList;
DROP TABLE IF EXISTS Deck;
DROP TABLE IF EXISTS Card;
DROP TABLE IF EXISTS Set;

-- drop all rolls
DROP ROLE IF EXISTS admin;
DROP ROLE IF EXISTS tournamentAdmin;
DROP ROLE IF EXISTS judge;
DROP ROLE IF EXISTS player;

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
    setID INTEGER NOT NULL REFERENCES Set(id),
  PRIMARY KEY (id)
);

--
-- The table of Decks.
--
CREATE TABLE Deck (
    id   SERIAL,
    name text,
  PRIMARY KEY (id)
);

--
-- The table of cards in a deck.
--
CREATE TABLE DeckList (
    id        INTEGER REFERENCES Deck(id),
    cardID    INTEGER NOT NULL REFERENCES Card(id),
    instances INTEGER NOT NULL DEFAULT 1 CHECK (instances >= 1 AND instances <= 4),
  PRIMARY KEY (id, cardID)
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
    date     date    NOT NULL DEFAULT current_date,
    tierID   integer NOT NULL REFERENCES Tier(id),
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
    deckID   INTEGER NOT NULL REFERENCES Deck(id),
    side     integer NOT NULL,
    result   CHAR(1) CHECK (result = 'W' or result = 'L'),
  PRIMARY KEY (matchID, playerID)
);

--
-- The table of banned people.
--
CREATE TABLE BannedPeople (
    personID     INTEGER NOT NULL REFERENCES Person(id),
    reason       text,
    startDate    date    NOT NULL DEFAULT current_date,
    legth_months INTEGER NOT NULL,
  PRIMARY KEY (personID)
);


--
-- Create view for full match info
--
CREATE VIEW fullMatchView AS
SELECT match.id as match_id, PlaysIn.playerID as player_id,
       p1.fname as player_name, PlaysIn.side, judge.personID as judge_id,
       p2.fname as judge_name, result, gameType.name
FROM Match INNER JOIN PlaysIn ON Match.id = PlaysIn.matchID
           INNER JOIN Player ON PlaysIn.playerID = Player.personID
           INNER JOIN Judge ON Match.judgeID = Judge.personID
           INNER JOIN person as p1 ON Player.personID = p1.id
           INNER JOIN person as p2 ON Judge.personID = p2.id
           INNER JOIN gametype ON Match.gameType = GameType.id;

--
-- Create view for full info on banned people
--
CREATE VIEW bannedPeopleInfo AS
SELECT personID, fname, lname, startDate, legth_months
FROM BannedPeople INNER JOIN person ON BannedPeople.personID = Person.id;

--
-- Create trigger to check deck size before inserting another card into a decklist
--
CREATE OR REPLACE FUNCTION check_deck_size()
  RETURNS TRIGGER AS
$$
DECLARE
  numCards INTEGER := 0;
BEGIN
  SELECT INTO numCards sum(instances) FROM DeckList WHERE NEW.id = DeckList.id;

  IF numCards + NEW.instances > 60 THEN
    RAISE NOTICE 'There are too many cards in that deck.';
    RETURN NULL;
  END IF;
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER check_deck_size
  BEFORE INSERT OR UPDATE ON DeckList
  FOR EACH ROW
  EXECUTE PROCEDURE check_deck_size();

--
-- Trigger to make sure a person does not play in and also judge the same match
--
CREATE OR REPLACE FUNCTION check_match_judge()
  RETURNS TRIGGER AS
$$
BEGIN
  IF exists(SELECT *
            FROM match
            WHERE Match.id = NEW.matchID
            AND match.judgeID = NEW.playerID) THEN
    RAISE NOTICE 'Cannot judge and play in the same match';
    RETURN NULL;
  END IF;
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER check_match_judge
  BEFORE INSERT OR UPDATE ON PlaysIn
  FOR EACH ROW
  EXECUTE PROCEDURE check_match_judge();

--
-- function to get all distinct matches given a tournament
--
CREATE OR REPLACE FUNCTION get_matches_by_tournament(text) RETURNS
  TABLE (matchID INTEGER) AS
$$
DECLARE
  tournamentName ALIAS FOR $1;
BEGIN
  RETURN QUERY
    SELECT DISTINCT Match.id
    FROM Match INNER JOIN tournament ON Match.tournamentID = Tournament.id
    WHERE tournament.name = tournamentName;
END;
$$LANGUAGE plpgsql;

--
-- calculate the points give a players first and last name
--
CREATE OR REPLACE FUNCTION get_points_for_player(text, text) RETURNS
  TABLE (points BIGINT) AS
$$
DECLARE
  firstName ALIAS FOR $1;
  lastName ALIAS FOR $2;
BEGIN
  RETURN QUERY
    SELECT coalesce(sum(tier.weight), 0)
    FROM PlaysIn INNER JOIN Person ON playerID = id
                 INNER JOIN match ON PlaysIn.matchID = Match.id
                 INNER JOIN tournament ON Match.tournamentID = Tournament.id
                 INNER JOIN tier ON Tournament.tierID = Tier.id
    WHERE fname = firstName
    AND lname = lastName
    AND result = 'W';
END;
$$LANGUAGE plpgsql;

--
-- Create the rolls.
--
CREATE ROLE admin;
CREATE ROLE tournamentAdmin;
CREATE ROLE judge;
CREATE ROLE player;

--
-- Remove access from all rolls before restoring it.
--
REVOKE ALL ON ALL TABLES IN SCHEMA public from admin;
REVOKE ALL ON ALL TABLES IN SCHEMA public from tournamentAdmin;
REVOKE ALL ON ALL TABLES IN SCHEMA public from judge;
REVOKE ALL ON ALL TABLES IN SCHEMA public from player;

--
-- Give admin back power.
--
GRANT ALL ON ALL TABLES IN SCHEMA public to admin;

--
-- Rules for player roll
--
GRANT SELECT , INSERT , UPDATE , DELETE ON Deck to player;
GRANT SELECT , INSERT , UPDATE , DELETE ON Decklist to player;
GRANT UPDATE ON Person to player;
GRANT UPDATE ON Player to player;
GRANT SELECT ON Card TO player;
GRANT SELECT ON Set TO player;
GRANT SELECT ON Match TO player;
GRANT SELECT ON PlaysIn TO player;
GRANT SELECT ON Tournament TO player;
GRANT SELECT ON GameType TO player;
GRANT SELECT ON Tier TO player;

--
-- Rules for judge roll.
--
GRANT SELECT , INSERT , UPDATE ON BannedPeople to judge;
GRANT SELECT , UPDATE ON Match to judge;
GRANT SELECT , UPDATE ON PlaysIn to judge;
GRANT SELECT , UPDATE ON Judge to judge;
GRANT SELECT ON Deck TO judge;
GRANT SELECT ON DeckList TO judge;
GRANT SELECT ON Card TO judge;
GRANT SELECT ON Set TO judge;
GRANT SELECT ON Match TO judge;
GRANT SELECT ON PlaysIn TO judge;
GRANT SELECT ON Tournament TO judge;
GRANT SELECT ON GameType TO judge;
GRANT SELECT ON Tier TO judge;

--
-- Rules for tournamentAdmin roll.
--
GRANT SELECT , INSERT , UPDATE ON BannedPeople to tournamentAdmin;
GRANT SELECT , INSERT , UPDATE ON Match to tournamentAdmin;
GRANT SELECT , INSERT , UPDATE ON PlaysIn to tournamentAdmin;
GRANT SELECT , INSERT , UPDATE ON Tournament to tournamentAdmin;
GRANT SELECT , UPDATE ON Judge to tournamentAdmin;
GRANT SELECT ON Deck TO tournamentAdmin;
GRANT SELECT ON DeckList TO tournamentAdmin;
GRANT SELECT ON Card TO tournamentAdmin;
GRANT SELECT ON Set TO tournamentAdmin;
GRANT SELECT ON Match TO tournamentAdmin;
GRANT SELECT ON PlaysIn TO tournamentAdmin;
GRANT SELECT ON Tournament TO tournamentAdmin;
GRANT SELECT ON GameType TO tournamentAdmin;
GRANT SELECT ON Tier TO tournamentAdmin;