-- Anders Lykkehoy
-- Lab05
-- Database Systems

-- 1. Show the cities of agents booking an order for a customer whose id is 'c006'. Use joins
-- this time; no subqueries.
SELECT agents.city
FROM agents INNER JOIN orders on agents.aid = orders.aid
WHERE orders.cid = 'c006';

-- 2. Show the ids of products ordered through any agent who makes at least one order for
-- a customer in Beijing, sorted by pid from highest to lowest. Use joins; no subqueries.

-- 3. Show the names of customers who have never placed an order. Use a subquery.
SELECT name
FROM customers
WHERE cid NOT IN (
  SELECT cid
  FROM orders
);

-- 4. Show the names of customers who have never placed an order. Use an outer join.
SELECT customers.name
FROM customers LEFT OUTER JOIN orders ON customers.cid = orders.cid
WHERE orders.ordno ISNULL;

-- 5. Show the names of customers who placed at least one order through an agent in their
-- own city, along with those agent(s') names.


-- 6. Show the names of customers and agents living in the same city, along with the name
-- of the shared city, regardless of whether or not the customer has ever placed an order
-- with that agent.
SELECT customers.name, agents.name, customers.city
FROM customers INNER JOIN agents ON customers.city = agents.city;

-- 7. Show the name and city of customers who live in the city that makes the fewest
-- different kinds of products. (Hint: Use count and group by on the Products table.)