--BOOK 2 PRACTICE QUESTIONS

-- Purchase Income by Dealership
-- 1. Write a query that shows the total purchase sales income per dealership.
SELECT d.business_name, SUM(price) as "Total Purchase Income"
FROM dealerships d
JOIN sales s ON d.dealership_id = s.dealership_id
WHERE s.sales_type_id = 1
GROUP BY d.dealership_id
ORDER BY d.dealership_id;

-- 2. Write a query that shows the purchase sales income per dealership for the current month.
SELECT d.business_name, SUM(price) as "Total Purchase Income for Current Month"
FROM dealerships d
JOIN sales s ON d.dealership_id = s.dealership_id
WHERE s.sales_type_id = 1
	AND EXTRACT (MONTH FROM s.purchase_date) = EXTRACT (MONTH FROM CURRENT_DATE)
GROUP BY d.dealership_id
ORDER BY d.dealership_id;

-- 3. Write a query that shows the purchase sales income per dealership for the current year.
SELECT d.business_name, SUM(price) as "Total Purchase Income for Current Year"
FROM dealerships d
JOIN sales s ON d.dealership_id = s.dealership_id
WHERE s.sales_type_id = 1
	AND EXTRACT (YEAR FROM s.purchase_date) = EXTRACT (YEAR FROM CURRENT_DATE)
GROUP BY d.dealership_id
ORDER BY d.dealership_id;

-- Lease Income by Dealership
-- 1. Write a query that shows the total lease income per dealership.
SELECT d.business_name, SUM(price) as "Total Lease Income"
FROM dealerships d
JOIN sales s ON d.dealership_id = s.dealership_id
WHERE s.sales_type_id = 2
GROUP BY d.dealership_id
ORDER BY d.dealership_id;

-- 2. Write a query that shows the lease income per dealership for the current month.
SELECT d.business_name, SUM(price) as "Total Lease Income for Current Month"
FROM dealerships d
JOIN sales s ON d.dealership_id = s.dealership_id
WHERE s.sales_type_id = 2
	AND EXTRACT (MONTH FROM s.purchase_date) = EXTRACT (MONTH FROM CURRENT_DATE)
	AND EXTRACT (YEAR FROM s.purchase_date) = EXTRACT (YEAR FROM CURRENT_DATE)
GROUP BY d.dealership_id
ORDER BY d.dealership_id;

-- 3. Write a query that shows the lease income per dealership for the current year.
SELECT d.business_name, SUM(price) as "Total Lease Income for Current Year"
FROM dealerships d
JOIN sales s ON d.dealership_id = s.dealership_id
WHERE s.sales_type_id = 2
	AND EXTRACT (YEAR FROM s.purchase_date) = EXTRACT (YEAR FROM CURRENT_DATE)
GROUP BY d.dealership_id
ORDER BY d.dealership_id;

-- Total Income by Employee
-- 1. Write a query that shows the total income (purchase and lease) per employee.
SELECT e.first_name, e.last_name, SUM(s.price) AS "Total Income"
FROM employees e
JOIN sales s ON e.employee_id = s.employee_id
GROUP BY e.employee_id;

-- Available Models
-- 1. Across all dealerships, which model of vehicle has the lowest current inventory? This will help dealerships know which models the purchase from manufacturers.
SELECT vmod.name, COUNT(vmod.vehicle_model_id) as vehicle_count
FROM vehicles v
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemodels vmod ON vt.model_id = vmod.vehicle_model_id
GROUP BY vmod.vehicle_model_id
ORDER BY vehicle_count ASC;

-- 2. Across all dealerships, which model of vehicle has the highest current inventory? This will help dealerships know which models are, perhaps, not selling.
SELECT vmod.name, COUNT(vmod.vehicle_model_id) as vehicle_count
FROM vehicles v
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemodels vmod ON vt.model_id = vmod.vehicle_model_id
GROUP BY vmod.vehicle_model_id
ORDER BY vehicle_count DESC;

-- Diverse Dealerships
-- 1. Which dealerships are currently selling the least number of vehicle models? This will let dealerships market vehicle models more effectively per region.
SELECT d.business_name, COUNT(DISTINCT vmod.vehicle_model_id) as "Number of Models"
FROM vehicles v
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemodels vmod ON vt.model_id = vmod.vehicle_model_id
JOIN sales s ON v.vehicle_id = s.vehicle_id
JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY d.dealership_id
ORDER BY "Number of Models" ASC;

-- 2. Which dealerships are currently selling the highest number of vehicle models? This will let dealerships know which regions have either a high population, or less brand loyalty.
SELECT d.business_name, COUNT(DISTINCT vmod.vehicle_model_id) as "Number of Models"
FROM vehicles v
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemodels vmod ON vt.model_id = vmod.vehicle_model_id
JOIN sales s ON v.vehicle_id = s.vehicle_id
JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY d.dealership_id
ORDER BY "Number of Models" DESC;

-- Carnival Sales Reps
-- Employee Reports
-- 1. How many emloyees are there for each role?
SELECT et.name, COUNT(et.employee_type_id)
FROM employees e
JOIN employeetypes et ON e.employee_type_id = et.employee_type_id
GROUP BY et.employee_type_id;

-- 2. How many finance managers work at each dealership?
SELECT d.business_name, COUNT(e.employee_id) as "Number of Finance Managers"
FROM employees e
JOIN employeetypes et ON e.employee_type_id = et.employee_type_id
JOIN dealershipemployees de ON e.employee_id = de.employee_id
JOIN dealerships d ON de.dealership_id = d.dealership_id
WHERE et.name = 'Finance Manager'
GROUP BY de.dealership_id, d.business_name
ORDER BY de.dealership_id;

-- 3. Get the names of the top 3 employees who work shifts at the most dealerships?
SELECT e.first_name, e.last_name, COUNT(e.employee_id) as "Number of Dealerships Employed At"
FROM employees e
JOIN dealershipemployees de ON e.employee_id = de.employee_id
GROUP BY e.employee_id
ORDER BY "Number of Dealerships Employed At" DESC;

-- 4. Get a report on the top two employees who have made the most sales through leasing vehicles.
SELECT e.first_name, e.last_name, COUNT(e.employee_id) as "num_of_leases"
FROM employees e
JOIN sales s ON e.employee_id = s.employee_id
WHERE s.sales_type_id = 2
GROUP BY e.employee_id
ORDER BY "num_of_leases" DESC
LIMIT 2;

-- States With Most Customers
-- 1. What are the top 5 US states with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
SELECT c.state, COUNT(c.customer_id) AS "Purchases per State"
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY state
ORDER BY "Purchases per State" DESC
LIMIT 5;

-- 2. What are the top 5 US zipcodes with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
SELECT c.zipcode, COUNT(c.customer_id) AS "Purchases per Zip"
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY zipcode
ORDER BY "Purchases per Zip" DESC
LIMIT 5;

-- 3. What are the top 5 dealerships with the most customers?
SELECT d.business_name, COUNT(c.customer_id) as "Number of Customers"
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY d.dealership_id
ORDER BY "Number of Customers" DESC
LIMIT 5;

-- Practice: Carnival Views
-- 1. Create a view that lists all vehicle body types, makes and models.
CREATE VIEW vehicle_types AS
	SELECT vbt.name AS Body, vma.name AS Make, vmo.name AS Model
	FROM vehicletypes vt
	JOIN vehiclebodytypes vbt ON vt.body_type_id = vbt.vehicle_body_type_id
	JOIN vehiclemakes vma ON vt.make_id = vma.vehicle_make_id
	JOIN vehiclemodels vmo ON vt.model_id = vmo.vehicle_model_id
	
SELECT * FROM vehicle_types;

-- 2. Create a view that shows the total number of employees for each employee type.
CREATE VIEW employees_per_type AS
	SELECT et.name, COUNT(et.employee_type_id)
	FROM employees e
	JOIN employeetypes et ON e.employee_type_id = et.employee_type_id
	GROUP BY et.employee_type_id;
	
SELECT * FROM employees_per_type;

-- 3. Create a view that lists all customers without exposing their emails, phone numbers and street address.
CREATE VIEW customer_list AS
	SELECT c.customer_id, c.first_name, c.last_name, c.company_name
	FROM customers c;
	
SELECT * FROM customer_list;

-- 4. Create a view named sales2018 that shows the total number of sales for each sales type for the year 2018.
CREATE VIEW sales2018 AS
	SELECT st.name, COUNT(s.sale_id) AS "Number of Sales in 2018"
	FROM sales s
	JOIN salestypes st ON s.sales_type_id = st.sales_type_id
	WHERE EXTRACT (YEAR FROM s.purchase_date) = 2018
	GROUP BY st.name;
	
SELECT * FROM sales2018;

-- 5. Create a view that shows the employee at each dealership with the most number of sales.
CREATE VIEW dealership_top_employees AS
SELECT d.business_name, e.first_name, e.last_name			
FROM dealerships d
JOIN employees e ON e.employee_id = (SELECT e.employee_id
									FROM sales s
									JOIN employees e ON s.employee_id = e.employee_id
									WHERE s.dealership_id = d.dealership_id
									GROUP BY e.employee_id, s.dealership_id
									ORDER BY COUNT(s.employee_id) DESC
									LIMIT 1)
ORDER BY d.dealership_id;

SELECT * FROM dealership_top_employees;