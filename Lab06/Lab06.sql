-- Anders Lykkehoy
-- Lab06
-- Database Systems

-- 1. Display the name and city of customers who live in any city that makes the most
-- different kinds of products. (There are two cities that make the most different
-- products. Return the name and city of customers from either one of those.)

-- 2. Display the names of products whose priceUSD is at or above the average priceUSD, in
-- reverse-alphabetical order.

-- 3. Display the customer name, pid ordered, and the total for all orders, sorted by total
-- from low to high.

-- 4. Display all customer names (in reverse alphabetical order) and their total ordered,
-- and nothing more. Use coalesce to avoid showing NULLs.

-- 5. Display the names of all customers who bought products from agents based in
-- Newark along with the names of the products they ordered, and the names of the
-- agents who sold it to them.

-- 6. Write a query to check the accuracy of the totalUSD column in the Orders table. This
-- means calculating Orders.totalUSD from data in other tables and comparing those
-- values to the values in Orders.totalUSD. Display all rows in Orders where
-- Orders.totalUSD is incorrect, if any.

-- 7. What’s the difference between a LEFT OUTER JOIN and a RIGHT OUTER JOIN? Give
-- example queries in SQL to demonstrate. (Feel free to use the CAP database to make
-- your points here.)