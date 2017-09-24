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

-- 3. Get	the	ids	and	names	of	customers	who	did	not	place	an	order	through	agent	a03.
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

-- 6. Get	the	name,	discount,	and	city	for	all	customers	who	place	orders	through	agents	in
-- Tokyo	or	New	York.

-- 7. Get	all	customers	who	have	the	same	discount	as	that	of	any	customers	in	Duluth	or
-- London