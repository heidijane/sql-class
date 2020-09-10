-- Employee Reports

-- Best Sellers

-- 1. Who are the top 5 employees for generating sales income?
SELECT e.first_name, e.last_name, SUM(s.price) AS "Total Sales Income"
FROM employees e
JOIN sales s ON e.employee_id = s.employee_id
WHERE s.sales_type_id = 1
GROUP BY e.employee_id
ORDER BY "Total Sales Income" DESC
LIMIT 5;

-- 2. Who are the top 5 dealership for generating sales income?
SELECT d.business_name, SUM(s.price) AS "Total Sales Income"
FROM dealerships d
JOIN sales s ON d.dealership_id = s.dealership_id
WHERE s.sales_type_id = 1
GROUP BY d.dealership_id
ORDER BY "Total Sales Income" DESC
LIMIT 5;

-- 3. Which vehicle model generated the most sales income?
SELECT vmo.name, SUM(s.price) AS "Total Sales Income"
FROM sales s
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemodels vmo ON vt.model_id = vmo.vehicle_model_id
WHERE s.sales_type_id = 1
GROUP BY vt.model_id, vmo.name
ORDER BY "Total Sales Income" DESC
LIMIT 1;

-- Top Performance
-- 1. Which employees generate the most income per dealership?
SELECT d.business_name, CONCAT(e.first_name, ' ', e.last_name) AS "Top Employee"			
FROM dealerships d
JOIN employees e ON e.employee_id = (SELECT e.employee_id
									FROM sales s
									JOIN employees e ON s.employee_id = e.employee_id
									WHERE s.dealership_id = d.dealership_id
									GROUP BY e.employee_id, s.dealership_id
									ORDER BY SUM(s.price) DESC
									LIMIT 1)
ORDER BY d.dealership_id;

-- Dealership Reports

-- Inventory
-- 1. In our Vehicle inventory, show the count of each Model that is in stock.
SELECT vm.name, COUNT(v.vehicle_id) AS "Number in Stock"
FROM vehicles v
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemodels vm ON vt.model_id = vm.vehicle_model_id
GROUP BY vm.vehicle_model_id
ORDER BY vm.name;

-- 2. In our Vehicle inventory, show the count of each Make that is in stock.
SELECT vm.name, COUNT(v.vehicle_id) AS "Number in Stock"
FROM vehicles v
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemakes vm ON vt.model_id = vm.vehicle_make_id
GROUP BY vm.vehicle_make_id
ORDER BY vm.name;

-- 3. In our Vehicle inventory, show the count of each BodyType that is in stock.
SELECT vbt.name, COUNT(v.vehicle_id) AS "Number in Stock"
FROM vehicles v
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclebodytypes vbt ON vt.body_type_id = vbt.vehicle_body_type_id
GROUP BY vbt.vehicle_body_type_id
ORDER BY vbt.name;

-- Purchasing Power
-- 1. Which US state's customers have the highest average purchase price for a vehicle?
SELECT c.state, ROUND(AVG(s.price)) AS "Average Price"
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.state
ORDER BY "Average Price" DESC;

-- 2. Now using the data determined above, which 5 states have the customers with the highest average purchase price for a vehicle?
SELECT c.state, ROUND(AVG(s.price)) AS "Average Price"
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.state
ORDER BY "Average Price" DESC
LIMIT 5;

-- --Old questions

-- 1. For each dealership, show the count of each vehicle model that it currently has in stock.
-- This one is weird because the only connection between dealerships and vehicles is sales which means they aren't currently in stock...
-- SELECT d.business_name, vm.name, COUNT(s.sale_id) AS "Number in Stock"
-- FROM dealerships d
-- JOIN sales s ON d.dealership_id = s.dealership_id
-- JOIN vehicles v ON s.vehicle_id = v.vehicle_id
-- JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
-- JOIN vehiclemodels vm ON vt.model_id = vm.vehicle_model_id
-- GROUP BY vm.vehicle_model_id, d.business_name
-- ORDER BY "Number in Stock" DESC;

-- --Top 5 states with the most customers
-- CREATE VIEW top_5_states_by_customer_count AS
-- 	SELECT c.state, COUNT(c.customer_id) AS "Number of Customers"
-- 	FROM customers c
-- 	JOIN sales s ON c.customer_id = s.customer_id
-- 	GROUP BY c.state
-- 	ORDER BY "Number of Customers" DESC
-- 	LIMIT 5;
	
-- SELECT * FROM top_5_states_by_customer_count;

-- -- 2. Of the 5 US states with the most customers that you determined above, which of those have the customers with the highest average purchase price for a vehicle?
-- SELECT c.state, ROUND(AVG(s.price)) AS "Average Price"
-- FROM customers c
-- JOIN sales s ON c.customer_id = s.customer_id
-- JOIN top_5_states_by_customer_count top5 ON c.state = top5.state
-- GROUP BY c.state
-- ORDER BY "Average Price" DESC;