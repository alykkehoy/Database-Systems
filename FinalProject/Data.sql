----------------------------------------------------------------------------------------
-- Magic the Gathering
-- Organized Play
-- by Anders Lykkehoy
----------------------------------------------------------------------------------------

SELECT *
FROM player INNER JOIN person ON player.personid = person.id
            INNER JOIN card ON player.favcard = card.id;

SELECT *
FROM judge INNER JOIN person ON judge.personid = person.id
           INNER JOIN judgelevel ON judge.level = judgelevel.level;


INSERT INTO set(name, year)
VALUES
  ('Ixalan', 2017),
  ('Hour of Devastation', 2017),
  ('Amonkhet', 2017),
  ('Aether Revolt', 2017),
  ('Kaladesh', 2016),
  ('Eldritch Moon', 2016),
  ('Shadows over Innistrad', 2016),
  ('Oath of the GateWatch', 2016),
  ('Battle For Zendikar', 2015);

INSERT INTO card (name, setid)
VALUES
--   All white Ixalan cards
  ('Adanto Vanguard', 1),
  ('Ashes of the Abhorrent', 1),
  ('Axis of Mortality', 1),
  ('Bellowing Aegisaur', 1),
  ('Bishop of Rebirth', 1),
  ('Bishop’s Soldier', 1),
  ('Bright Reprisal', 1),
  ('Demystify', 1),
  ('Duskborne Skymarcher', 1),
  ('Emissary of Sunrise', 1),
  ('Encampment Keeper', 1),
  ('Glorifier of Dusk', 1),
  ('Goring Ceratops', 1),
  ('Imperial Aerosaur', 1),
  ('Imperial Lancer', 1),
  ('Inspiring Cleric', 1),
  ('Ixalan’s Binding', 1),
  ('Kinjalli’s Caller', 1),
  ('Kinjalli’s Sunwing', 1),
  ('Legion Conquistador', 1),
  ('Legion’s Judgment', 1),
  ('Looming Altisaur', 1),
  ('Mavren Fein, Dusk Apostle', 1),
  ('Paladin of the Bloodstained', 1),
  ('Pious Interdiction', 1),
  ('Priest of the Wakening Sun', 1),
  ('Pterodon Knight', 1),
  ('Queen’s Commission', 1),
  ('Rallying Roar', 1),
  ('Raptor Companion', 1),
  ('Ritual of Rejuvenation', 1),
  ('Sanguine Sacrament', 1),
  ('Settle the Wreckage', 1),
  ('Sheltering Light', 1),
  ('Shining Aerosaur', 1),
  ('Skyblade of the Legion', 1),
  ('Slash of Talons', 1),
  ('Steadfast Armasaur', 1),
  ('Sunrise Seeker', 1),
  ('Territorial Hammerskull', 1),
  ('Tocatli Honor Guard', 1),
  ('Vampire’s Zeal', 1),
  ('Wakening Sun’s Avatar', 1);


INSERT INTO person (fname, lname, bday, bmonth, byear)
VALUES
  ('Anders', 'Lykkehoy', 5, 12, 1994),
  ('Richard', 'Garfield', 26, 6, 1963),
  ('Bob', 'Smith', 2, 3, 1990),
  ('Some', 'Guy', 1, 1, 1991);

INSERT INTO judgelevel (level, name, yearsvalid)
VALUES
  (1, 'Regular REL Judge', 1),
  (2, 'Competitive REL Judge', 1),
  (3, 'Premier Judge', 1);

INSERT INTO judge (personid, level, certyear)
VALUES
  (2, 3, 2017);

INSERT INTO player (personid, favcard)
VALUES
  (1, 1),
  (2, 1);

INSERT INTO gametype (name)
VALUES
  ('Standard'),
  ('Booster Draft'),
  ('Sealed Deck'),
  ('Commander'),
  ('Vintage'),
  ('Two Headed Giant');

INSERT INTO tier (name, weight)
VALUES
  ('Best', 100);

INSERT INTO tournament (name, location, teirid)
VALUES
  ('Super amazing tournament of champions', 'the moon', 1);

INSERT INTO match (tournamentid, gametype, judgeid)
VALUES
  (1, 1, 2);



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
