-- Anders Lykkehoy
-- Lab04
-- Database Systems

-- 1. Get	the	cities	of	agents	booking	an	order	for	a	customer	whose	cid	is	'c006'.
SELECT city
FROM agents
WHERE aid in (
  SELECT aid
  FROM orders
  WHERE cid = 'c006'
);

-- 2. Get	the	distinct	ids	of	products	ordered	through	any	agent	who	takes	at	least	one
-- order	from	a	customer	in	Beijing,	sorted	by	pid	from	highest	to	lowest.	(This	is	not	the
-- same	as	asking	for	ids	of	products	ordered	by	customers	in	Beijing.)
SELECT DISTINCT pid
FROM orders
WHERE aid IN (
  SELECT aid
  FROM orders
  WHERE cid IN (
    SELECT cid
    FROM customers
    WHERE city = 'Beijing'
  )
) ORDER BY pid DESC;

-- 3. Get	the	ids	and	names	of	customers	who	did	not	place	an order	through	agent	a03.
SELECT cid, name
FROM customers
WHERE cid NOT IN (
  SELECT cid
  FROM orders
  WHERE aid = 'a03'
);

-- 4. Get	the	ids	of	customers	who	ordered	both	product	p01	and	p07.
SELECT cid
FROM orders
WHERE cid IN (
  SELECT cid
  FROM orders
  WHERE pid = 'p01'
) AND pid = 'p07';

-- 5. Get	the	ids	of	products	not	ordered	by	any	customers	who	placed	any	order	through
-- agents	a02	or	a03,	in	pid	order	from	highest	to	lowest.
SELECT pid
FROM products
WHERE pid NOT IN (
  SELECT pid
  FROM orders
  WHERE cid IN (
    SELECT cid
    FROM orders
    WHERE aid = 'a02' OR aid = 'a03'
  )
)ORDER BY pid DESC;

-- 6. Get	the	name,	discount,	and	city	for	all	customers	who	place	orders	through	agents	in
-- Tokyo	or	New	York.
SELECT name, discountpct, city
FROM customers
WHERE cid IN (
  SELECT cid
  FROM orders
  WHERE aid IN (
    SELECT aid
    FROM agents
    WHERE city = 'Tokyo' or city = 'New York'
  )
);

-- 7. Get	all	customers	who	have	the	same	discount	as	that	of	any	customers	in	Duluth	or
-- London
SELECT *
FROM customers
WHERE discountpct IN (
  SELECT discountpct
  FROM customers
  WHERE city = 'Duluth' or city = 'London'
);

-- 8. Tell	me	about	check	constraints:	What	are	they?	What	are	they	good	for?	What’s	the
-- advantage	of	putting	that	sort	of	thing	inside	the	database?	Make	up	some	examples
-- of	good	uses	of	check	constraints	and	some	examples	of	bad	uses	of	check	constraints.
-- Explain	the	differences	in	your	examples	and	argue	your	case.

/*
Check constraints are requirements set on a column. An advantage of check constraints is it forces data
to be valid. An example would be if a column is day_of_the_week, and someone tried to use the value 'today'.
The check constraint could catch that and not allow it into the database.

Good Uses:
 - not null
  - forces you to have a value
 - am or pm
  - if the database is not using military time, makes the time more precise and forces a valid choice of
  either am or pm.
 - month
  - forces a valid month 1 - 12. More than likely possible values are not going to change.

Bad Uses:
  - Department
    - a department could be added or cut causing some values to no longer be valid, or new valid values
    to not be allowed.
  - Project
    - just like departments, projects can come and go making the database less accurate to the real world
    information.
 */