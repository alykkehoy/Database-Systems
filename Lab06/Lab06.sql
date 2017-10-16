-- Anders Lykkehoy
-- Lab06
-- Database Systems

-- 1. Display the name and city of customers who live in any city that makes the most
-- different kinds of products. (There are two cities that make the most different
-- products. Return the name and city of customers from either one of those.)
SELECT name, city
FROM customers
WHERE city IN (
  SELECT city
  FROM products as p1
  GROUP BY p1.city
  HAVING count(p1.pid) = (
    SELECT count(p2.pid)
    FROM products AS p2
    GROUP BY p2.city
    ORDER BY count(p2.pid) DESC
    LIMIT 1
  )
);

-- 2. Display the names of products whose priceUSD is at or above the average priceUSD, in
-- reverse-alphabetical order.
SELECT name
FROM products
WHERE priceusd >= (
  SELECT sum(priceusd) / count(priceusd)
  FROM products
);

-- 3. Display the customer name, pid ordered, and the total for all orders, sorted by total
-- from low to high.
SELECT name, pid, totalUSD
FROM orders INNER JOIN customers ON orders.cid = customers.cid
ORDER BY totalusd ASC;

-- 4. Display all customer names (in reverse alphabetical order) and their total ordered,
-- and nothing more. Use coalesce to avoid showing NULLs.
SELECT customers.name, coalesce(sum(totalUSD), 0)
FROM orders RIGHT OUTER JOIN customers ON orders.cid = customers.cid
GROUP BY customers.cid
ORDER BY customers.name DESC;

-- 5. Display the names of all customers who bought products from agents based in
-- Newark along with the names of the products they ordered, and the names of the
-- agents who sold it to them.
SELECT customers.name, orders.pid, agents.name
FROM orders INNER JOIN customers ON orders.cid = customers.cid
            INNER JOIN agents ON orders.aid = agents.aid
WHERE agents.city = 'Newark';

-- 6. Write a query to check the accuracy of the totalUSD column in the Orders table. This
-- means calculating Orders.totalUSD from data in other tables and comparing those
-- values to the values in Orders.totalUSD. Display all rows in Orders where
-- Orders.totalUSD is incorrect, if any.
SELECT *
FROM orders INNER JOIN products ON orders.pid = products.pid
            INNER JOIN customers ON orders.cid = customers.cid
WHERE orders.totalUSD <> (products.priceusd * orders.quantity * (1 - (customers.discountpct / 100)));

-- 7. What’s the difference between a LEFT OUTER JOIN and a RIGHT OUTER JOIN? Give
-- example queries in SQL to demonstrate. (Feel free to use the CAP database to make
-- your points here.)

-- The difference between right outer join and left outer join is the order the tables are joined
-- in. For a left outer join, the right table is joined into the left one. Where there is no match
-- in the right table, NULL is entered. This works the opposit way for a right outer join.

-- If you were to say "customers left outer join orders on cusotmers.cid = orders.cid", all orders
-- would be matched to their customers, but if there existed a customer who made no orders the fields
-- would left NULL