----------------------------------------------------------------------------------------
-- Magic the Gathering:
-- Organized Play
-- by Anders Lykkehoy
----------------------------------------------------------------------------------------


--
-- see total instances of a card across all decks
--
SELECT cardID, sum(instances) as rate
FROM DeckList
GROUP BY cardID
ORDER BY rate DESC;

--
-- see all the people who are still banned
--
SELECT id, fname, lname, reason, startDate, legth_months, age(current_date, startDate)
FROM bannedpeople INNER JOIN Person ON BannedPeople.personID = Person.id
WHERE extract(YEAR FROM age(current_date, startDate)) * 12 + extract(MONTH FROM age(current_date, startDate)) < legth_months;
