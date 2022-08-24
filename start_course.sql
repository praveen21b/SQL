-- drop databases
SHOW databases;

DROP DATABASE sql_hr;

DROP DATABASE IF EXISTS sys;

-- select columns
USE sql_hr;
SELECT  * 
FROM sql_hr.offices;

-- Return all the products
-- name
-- unit price
-- new price(unit price*1.1)
SELECT name, unit_price, (unit_price*1.1) AS new_price
FROM sql_inventory.products;

# WHERE clause
-- use to filter the data
SELECT *
FROM sql_store.customers
WHERE points > 3000;

-- comaparision operators: >, <, >=, <=, =, != or <>

SELECT *
FROM sql_store.customers
-- WHERE state = 'VA';
WHERE state != 'VA';

SELECT *
FROM sql_store.customers
WHERE birth_date>'1990-01-01';

-- Get the orders placed this year
SELECT *
FROM sql_store.orders
-- WHERE order_date BETWEEN 2022-01-01 and 2022-12-31
WHERE order_date >='2019-01-01' AND order_date = '2019-12-31';

# AND, OR, NOT conditions
SELECT *
FROM sql_store.customers
-- WHERE birth_date > '1990-01-01' AND  points > 1000;
-- WHERE birth_date > '1990-01-01' OR  points > 1000;
WHERE birth_date > '1990-01-01' OR  
		(points > 1000 AND state = 'VA');

-- From the order_items table,get the items
-- for order#6
-- where the total price is greater than 30
SELECT * -- , (unit_price * quantity) AS total_price
FROM sql_store.order_items
WHERE order_id = 6 AND (unit_price * quantity) > 30;

# IN  or NOT IN operator
SELECT*
FROM sql_store.customers
-- WHERE state ='VA'OR state='GA'OR state='FL'
WHERE state NOT IN ('VA','GA','FL');

-- Return products with quantity in stock equal to 49,38,72
SELECT *
FROM sql_inventory.products
WHERE quantity_in_stock in (49,38,72);

# BETWEEN operator
SELECT*
FROM sql_store.customers
-- WHERE points>1000 AND points<=3000;
WHERE points BETWEEN 1000 AND 3000; -- both range values or inclusive

-- Return customers born between 1/1/1990 and 1/1/2000
SELECT *
FROM sql_store.customers
where birth_date BETWEEN '1990-01-01' AND '2000-01-01';

# LIKE operator
-- customer name starts with 'b'
SELECT *
FROM sql_store.customers
WHERE last_name LIKE 'b%'; -- %b% or _b for single char before b

-- Get the customers whose addresses contain TRAIL or AVENUE
SELECT *
FROM sql_store.customers
WHERE address LIKE '%trail%' OR address LIKE '%avenue%';
-- phone numbers end with9
SELECT *
FROM sql_store.customers
WHERE phone LIKE '%9';

# REGEXP operator
SELECT *
FROM sql_store.customers
-- WHERE phone REGEXP '9$'; -- ^ beginning, $ end
WHERE phone REGEXP '9$|^8|1'; -- multiple search

SELECT *
FROM sql_store.customers
-- WHERE last_name REGEXP'[gim]e'; -- before e only g,i,m characters are allowed
-- ge
-- ie
-- me
WHERE last_name REGEXP '[a-h]e';

-- Get the customers whose
-- first names are ELKA or AMBUR
SELECT *
FROM sql_store.customers
-- WHERE first_name = 'elka' OR first_name = 'ambur';
-- WHERE first_name LIKE 'elka' OR first_name LIKE 'ambur';
WHERE first_name REGEXP 'elka|ambur';

-- last names end with EY or ON
SELECT *
FROM sql_store.customers
WHERE last_name REGEXP 'ey$|on$';

-- last names start with MY or contains SE
SELECT *
FROM sql_store.customers
WHERE last_name REGEXP '^my|se';

-- last names contain B followed by R or U
SELECT *
FROM sql_store.customers
WHERE last_name REGEXP 'b[ru]';

# IS NULL operator
SELECT *
FROM sql_store.customers
WHERE phone IS not NULL;
-- Get the orders that are not shipped
SELECT * 
FROM sql_store.orders
WHERE shipped_date IS NULL;

# order by clause
SELECT *
FROM sql_store.customers
-- ORDER BY first_name DESC;
ORDER BY state DESC, first_name;

-- get order_id 2 sorted based on their total price in descending order
SELECT *, (quantity * unit_price) AS total_price
FROM sql_store.order_items
where order_id = 2
ORDER BY total_price DESC;

# LIMIT clause
SELECT *
FROM sql_store.customers
-- LIMIT 3
LIMIT 6, 3; -- skip first 6 items and select next 3

-- get top 3 loyal customers i.e. more points
SELECT *
FROM sql_store.customers
ORDER BY points DESC
LIMIT 3;

# INNER JOIN clause
SELECT order_id, first_name,last_name, o.customer_id
FROM sql_store.orders o -- o as alias for orders tabels
INNER JOIN sql_store.customers c
	ON o.customer_id = c.customer_id;
    
-- joining order_items and prodicts
SELECT order_id, ot.product_id, name, quantity
FROM sql_store.order_items ot
INNER JOIN sql_store.products p
	ON ot.product_id = p.product_id;
    
# joining across database
SELECT *
FROM sql_store.order_items ot
INNER JOIN sql_inventory.products p
	ON ot.product_id = p.product_id;
    
# self join
SELECT e.employee_id, e.first_name, e.job_title, m.first_name AS manager_name
FROM sql_hr.employees e
JOIN sql_hr.employees m 
		ON e.reports_to = m.employee_id;
        
#multiple table join
SELECT o.order_id,
		o.order_date,
        c.first_name,
        c.last_name,
        os.name AS status
FROM sql_store.orders o
JOIN sql_store.customers c
	ON o.customer_id = c.customer_id
JOIN sql_store.order_statuses os
	ON o.status =os.order_status_id;
    
SELECT 
		p.date,
        p.invoice_id,
        p.amount,
        c.name, 
        pm.name AS pay_method
FROM sql_invoicing.clients c
JOIN sql_invoicing.payments p
	ON c.client_id = p.client_id
JOIN sql_invoicing.payment_methods pm
	ON p.payment_method = pm.payment_method_id;

# compound join conditions
-- composite primary key
SELECT *
FROM sql_store.order_items oi
JOIN sql_store.order_item_notes oin
	ON oi.product_id = oin.product_id
    AND oi.order_id = oin.order_Id;

# implicit join syntax
-- common use
SELECT *
FROM sql_store.orders o
JOIN sql_store.customers c
    ON o.customer_id = c.customer_id;

-- implicit
SELECT *
FROM sql_store.orders o, sql_store.customers c
WHERE o.customer_id = c.customer_id; -- important if not will get cross join

SELECT *
FROM sql_store.orders o, sql_store.customers c;

# outer join
SELECT * 
FROM sql_store.customers c
JOIN sql_store.orders o
	ON c.customer_id = o.customer_id;

SELECT 
	c.customer_id,
    c.first_name,
    o.order_id
FROM sql_store.customers c
LEFT OUTER JOIN sql_store.orders o
	ON c.customer_id = o.customer_id;
--
SELECT 
	p.product_id,
    p.name,
    oi.quantity
FROM sql_store.products p
LEFT JOIN sql_store.order_items oi
	ON p.product_id = oi.product_id;

# outer join between multiple tables
SELECT 
	c.customer_id,
    c.first_name,
    o.order_id
FROM sql_store.customers c
LEFT OUTER JOIN sql_store.orders o
	ON c.customer_id = o.customer_id
LEFT JOIN sql_store.shippers sh
	ON o.shipper_id = sh.shipper_id;
--
SELECT 
	o.order_date,
    o.order_id,
    c.first_name AS customer,
    sh.name AS shipper,
    os.name AS status
FROM sql_store.orders o
LEFT OUTER JOIN sql_store.customers c
	ON c.customer_id = o.customer_id
LEFT JOIN sql_store.shippers sh
	ON o.shipper_id = sh.shipper_id
LEFT JOIN sql_store.order_statuses os
	ON o.status = os.order_status_id
ORDER BY os.name  ;

# Self outer join
SELECT 
	e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM sql_hr.employees e
LEFT JOIN sql_hr.employees m
	ON e.reports_to = m.employee_id;

# USING clause
SELECT 
	o.order_id,
    c.first_name,
    sh.name AS shipper
FROM sql_store.orders o
JOIN sql_store.customers c
	-- ON o.customer_id = c.customer_id;
    USING (customer_id) -- when columns have same name
left JOIN sql_store.shippers sh
	USING (shipper_id);

--
SELECT *
FROM sql_store.order_items oi
JOIN sql_store.order_item_notes oin
	-- ON oi.product_id = oin.product_id AND oi.order_id = oin.order_Id
    USING (order_id,product_id);
-- 
SELECT 
	p.date,
    c.name AS client,
    p.amount,
    pm.name as payment_method
FROM sql_invoicing.payments p
JOIN sql_invoicing.clients c
	USING (client_id)
JOIN sql_invoicing.payment_methods pm
	ON pm.payment_method_id = p.payment_method;
    
# Natual joins
-- not recommended
SELECT
	o.order_id,
    c.first_name
FROM sql_store.customers c
NATURAL JOIN sql_store.orders o;
-- joins on common columns, here it is custmer_id

# CROSS JOIN claus
-- joining each element of one tabel with each element of other table.
SELECT 
	c.first_name AS customer,
    p.name AS product
FROM sql_store.customers c
CROSS JOIN sql_store.products p
-- FROM sql_store.customers c, sql_store.products p -- implicit
ORDER BY customer;
SELECT *
-- FROM sql_store.products p, sql_store.shippers sh
FROM sql_store.products p
CROSS JOIN sql_store.shippers sh
ORDER BY sh.name;

# UNION
SELECT 
	c.customer_id,
    c.first_name,
    c.points,
    'Bronze' AS type
FROM sql_store.customers c
WHERE c.points < 2000
UNION
SELECT 
	c.customer_id,
    c.first_name,
    c.points,
    'Silver' AS type
FROM sql_store.customers c
WHERE c.points BETWEEN 2000 AND 3000
UNION
SELECT 
	c.customer_id,
    c.first_name,
    c.points,
    'Gold' AS type
FROM sql_store.customers c
WHERE c.points > 3000
ORDER BY first_name;

# column attributes
-- insert, update, delete data
INSERT INTO sql_store.customers (
	first_name,
    last_name,
    birth_date,
    address,
    city,
    state)
values (
	'Praveen',
    'Hosamani',
    '1991-03-21',
    'Fischergasse 20/1',
    'Ulm',
    'BW');
SELECT * FROM sql_store.customers;

-- multiple row insertion
INSERT INTO sql_store.shippers (name)
VALUES ('shipper1'), -- 1st entry followed by comma and next row entry
		('shipper2'),
        ('shipper3');
        
-- Insert three rows in the products table
INSERT INTO sql_store.products (
	name,
    quantity_in_stock,
    unit_price)
VALUES ('abc',100,1.0),
		('def',200,2.0),
        ('ghi',300,3.0);

-- copy of a table
CREATE TABLE sql_invoicing.Invoices_archived AS
SELECT 
	inv.invoice_id,
    inv.number,
    c.name AS client,
    inv.invoice_date,
    inv.payment_date,
    inv.due_date
FROM sql_invoicing.invoices inv
JOIN sql_invoicing.clients c
	USING (client_id)
WHERE inv.payment_date IS NOT NULL
    