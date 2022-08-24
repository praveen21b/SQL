-- SELECT * FROM sql_store.orders
-- where order_date >= '2019-01-01'

-- use sql_store;
-- show tables 

-- select * 
-- from sql_store.order_items
-- where order_id = 6 and unit_price * quantity > 30

select * 
from sql_store.products
where quantity_in_stock in (49,38,72);

select * from sql_store.customers
where birth_date between '1990-01-01' and '2000-01-01';

-- pattern matching
select * 
from sql_store.customers
-- where last_name like 'b%'
where last_name like '%b%';
-- % any number of characters
-- _ single character

select *  from sql_store.customers
-- where (address like  '%trail%' or address like '%avenue%') 
where phone like'%9';

select * from sql_store.customers
-- where last_name like '%field%'
-- where last_name regexp 'field';
-- '^field' beginning of the string
-- 'field$' at the end of the string
-- where last_name regexp 'field|^mac|rose'; -- | logocal OR or multple search pattern
where last_name regexp '[gim]e'; -- ge, ie or me in the string or [a-h]e

select * from sql_store.customers
-- where first_name = 'elka' or first_name = 'ambur';
-- where last_name regexp 'ey$|on$';
-- where last_name regexp '^my|se';
where last_name regexp 'b[ru]';

select * from sql_store.customers
where phone is null;

select * from sql_store.orders
where shipped_date is null;

-- order by clause
select * from sql_store.customers
-- order by first_name desc
order by state desc, first_name;

select * from sql_store.order_items
where order_id = 2
order by quantity * unit_price desc;

-- Limit clause
select * from sql_store.customers
-- limit 3 -- 1st 3 entries
limit 6,3; -- skip 1st 6 entries

select * from sql_store.customers
order by points desc
limit 3;

-- inner joins
select order_id, first_name, last_name, c.customer_id
from sql_store.orders o
join sql_store.customers c
	-- on orders.customer_id = customers.customer_id
    on o.customer_id = c.customer_id;
    
select order_id, oi.product_id, quantity, oi.unit_price
from sql_store.order_items oi
join sql_store.products p
	on oi.product_id = p.product_id;
    
-- Joining across hte databases
select order_id, oi.product_id, quantity, oi.unit_price  
from sql_store.order_items oi
join sql_inventory.products p
	on oi.product_id = p.product_id;
    
-- self join
use sql_hr;

select
	e.employee_id,
    e.first_name,
    m.first_name as manager_name
from sql_hr.employees e 
join sql_hr.employees m
	on e.reports_to = m.employee_id;

-- joinging multiple tables
select 
	o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    os.name as status
from sql_store.orders o
join sql_store.customers c
	on o.customer_id = c.customer_id
join sql_store.order_statuses os
on o.status = os.order_status_id;

select py.date, py.invoice_id, py.amount, pm.name as 'payment methos', cl.name
from sql_invoicing.payments py
join sql_invoicing.payment_methods pm
	on py.payment_method = pm.payment_method_id
join sql_invoicing.clients cl
	on py.client_id = cl.client_id;
    
-- compound join condition
