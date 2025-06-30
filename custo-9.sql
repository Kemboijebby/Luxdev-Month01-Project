select *
from sales.customers
limit 10;

-- Get customer info for each order — who placed it, where they are, who the contact is.
SELECT 
  o.order_id,
  o.order_date,
  o.shipped_date,
  o.freight_cost,
  c.customer_id,
  c.company_name,
  c.contact_name,
  c.city,
  c.country
FROM 
  sales.orders o
JOIN 
  sales.customers c
ON 
  o.customer_id = c.customer_id;

--See which shipping company handled each order → useful for analyzing freight costs, delivery times, or shipper performance.
SELECT 
  o.order_id,
  o.order_date,
  o.shipped_date,
  s.shipper_id,
  s.company_name AS shipper_name,
  s.phone
FROM 
  sales.orders o
JOIN 
  sales.shippers s
ON 
  o.ship_via = s.shipper_id;

--Get the supplier details for each product — useful for supplier spend, sourcing analysis, or supplier performance dashboards.
SELECT 
  p.product_id,
  p.product_name,
  p.unit_price,
  s.supplier_id,
  s.company_name AS supplier_name,
  s.contact_name,
  s.country
FROM 
  sales.products p
JOIN 
  sales.suppliers s
ON 
  p.supplier_id = s.supplier_id;

--Find “open orders” → no shipped_date
SELECT *
FROM sales.orders
WHERE shipped_date IS NULL;

--Only open orders, placed in 1997, by customers in the USA.
SELECT 
  o.*
FROM 
  sales.orders o
JOIN 
  sales.customers c 
  ON o.customer_id = c.customer_id
WHERE 
  o.shipped_date IS NULL
  AND c.country = 'USA';

--Delayed orders
SELECT
  order_id,
  order_date,
  shipped_date,
  required_date,
  CASE
    WHEN shipped_date <= required_date THEN 'On Time'
    WHEN shipped_date > required_date THEN 'Late'
    ELSE 'Pending'
  END AS shipping_status
FROM
  sales.orders;

--Total orders per customer

SELECT
  customer_id,
  COUNT(*) AS total_orders
FROM
  sales.orders
GROUP BY
  customer_id
ORDER BY
  total_orders DESC;

--Total freight by shipper
SELECT
  ship_via AS shipper_id,
  SUM(freight_cost) AS total_freight
FROM
  sales.orders
GROUP BY
  ship_via
ORDER BY
  total_freight DESC;

--Avg freight cost per order
SELECT
  AVG(freight_cost) AS avg_freight
FROM
  sales.orders;

--Top 5 customers by orders
SELECT
  customer_id,
  COUNT(*) AS total_orders
FROM
  sales.orders
GROUP BY
  customer_id
ORDER BY
  total_orders DESC
LIMIT 5;


--create a view table // to be used as the fact table
CREATE OR REPLACE VIEW sales.vw_fact_orders AS
SELECT
  o.order_id,
  o.order_date,
  o.required_date,
  o.shipped_date,
  o.freight_cost,
  o.ship_via AS shipper_id,
  s.company_name AS shipper_name,
  s.phone AS shipper_phone,
  c.customer_id,
  c.company_name AS customer_name,
  c.contact_name,
  c.city AS customer_city,
  c.country AS customer_country,
  o.ship_city,
  o.ship_country,
  -- Date parts
  EXTRACT(YEAR FROM o.order_date) AS order_year,
  EXTRACT(MONTH FROM o.order_date) AS order_month,
  -- Delivery time
  CASE
    WHEN o.shipped_date IS NULL THEN NULL
    ELSE o.shipped_date - o.order_date
  END AS delivery_days,
  -- Status
  CASE
    WHEN o.shipped_date IS NULL THEN 'Pending'
    WHEN o.shipped_date <= o.required_date THEN 'On Time'
    ELSE 'Late'
  END AS shipping_status
FROM
  sales.orders o
JOIN
  sales.customers c ON o.customer_id = c.customer_id
JOIN
  sales.shippers s ON o.ship_via = s.shipper_id;

