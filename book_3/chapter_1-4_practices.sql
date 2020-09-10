-- Chapter 1
-- Practice: Employees

-- 1. Rheta Raymen an employee of Carnival has asked to be transferred to a different dealership location. 
-- She is currently at dealership 751. She would like to work at dealership 20. Update her record to reflect her transfer.

SELECT *
FROM employees e
WHERE e.last_name = 'Raymen';
-- Her employee id is 680

SELECT de.dealership_id, d.business_name, de.employee_id
FROM dealerships d
JOIN dealershipemployees de ON d.dealership_id = de.dealership_id
WHERE de.employee_id = 680;
-- She currently works for 2 dealerships

UPDATE dealershipemployees
SET dealership_id = 20
WHERE dealership_id = 751 AND employee_id = 680;

-- Practice: Sales

-- 2. A Sales associate needs to update a sales record because her customer want so pay wish Mastercard instead of American Express.
-- Update Customer, Layla Igglesden Sales record which has an invoice number of 2781047589.
SELECT *
FROM sales s
WHERE s.invoice_number = '2781047589';

UPDATE sales
SET payment_method = 'mastercard'
WHERE invoice_number = '2781047589';

-- Chapter 2
-- Practice - Employees

-- 1. A sales employee at carnival creates a new sales record for a sale they are trying to close. 
-- The customer, last minute decided not to purchase the vehicle. Help delete the Sales record with an invoice number of '7628231837'.
SELECT *
FROM sales s
WHERE s.invoice_number = '7628231837';

DELETE FROM sales
WHERE invoice_number = '7628231837';

-- 2. An employee was recently fired so we must delete them from our database. Delete the employee with employee_id of 35.
-- What problems might you run into when deleting? How would you recommend fixing it?

-- If you delete just the data from the employee table you would have orphaned rows in the dealershipemployees table.
-- Deleting the employee could also cause issues in the sales table, since if they have any sales their employee id would no longer point to anything.
-- I think the safest thing to do to avoid any foreign key or orphaned row isses would be to NOT delete the employee.
-- Rather an "active" column could be added to the employee table that is set to TRUE for current employees and FALSE for people who no longer work for the company.
-- By doing this you preserve the record of their actions in case you need it at a future date. Otherwise you would have to delete all their sales data.

-- Chapter 3/4

-- Inventory Management
-- Selling a Vehicle
-- Carnival would like to create a stored procedure that handles the case of updating their vehicle inventory when a sale occurs. 
-- They plan to do this by flagging the vehicle as is_sold which is a field on the Vehicles table. 
-- When set to True this flag will indicate that the vehicle is no longer available in the inventory. 
-- Why not delete this vehicle? We don't want to delete it because it is attached to a sales record.

-- Returning a Vehicle
-- Carnival would also like to handle the case for when a car gets returned by a customer. 
-- When this occurs they must add the car back to the inventory and mark the original sales record as returned = True.

-- Carnival staff are required to do an oil change on the returned car before putting it back on the sales floor. 
-- In our stored procedure, we must also log the oil change within the OilChangeLog table.

-- Goals
-- Use the story above and extract the requirements.
-- Build two stored procedures for Selling a car and Returning a car. Be ready to share with your class or instructor your result.

-- Selling a Vehicle

-- Okay, first it sounds like I need to create a new "is_sold" column on the vehicles table
-- add new column
ALTER TABLE vehicles 
ADD COLUMN is_sold BOOLEAN;

-- set default to false
ALTER TABLE vehicles
ALTER COLUMN is_sold SET DEFAULT FALSE;

-- update is_sold of any vehicles that have sale records to true
UPDATE vehicles
SET is_sold = FALSE;
UPDATE vehicles
SET is_sold = TRUE
WHERE vehicle_id = ANY(SELECT vehicle_id FROM sales);

-- create the stored procedure
CREATE OR REPLACE PROCEDURE sell_vehicle(IN v_id int)
LANGUAGE plpgsql
AS $$
BEGIN

UPDATE vehicles SET is_sold = TRUE WHERE vehicle_id = v_id;

END
$$;

-- call the procedure
CALL sell_vehicle(1);
-- IT WORKS!!

-- Returning a Vehicle

-- Looks like first I need to add a new "returned" column to sales.
ALTER TABLE sales
ADD COLUMN returned BOOLEAN NOT NULL DEFAULT FALSE;

-- I also need to add an OilChangeLog table
CREATE TABLE OilChangeLog (
   oil_change_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
   vehicle_id INT REFERENCES vehicles (vehicle_id),
   change_date DATE
);
ALTER TABLE OilChangeLog
ALTER COLUMN change_date SET DEFAULT NOW();

-- Create a stored procedure that...
-- 1. sets the returned column on the sale to true
-- 2. sets the is_sold column on vehicles to false
-- 3. inserts a record into the oilchangelog
CREATE OR REPLACE PROCEDURE return_vehicle(IN invoiceNum VARCHAR(50))
LANGUAGE plpgsql
AS $$
BEGIN

UPDATE sales SET returned = TRUE WHERE invoice_number = invoiceNum;
UPDATE vehicles SET is_sold = FALSE WHERE vehicle_id = (SELECT vehicle_id FROM sales WHERE invoice_number = invoiceNum);
INSERT INTO oilchangelog(vehicle_id)
SELECT s.vehicle_id
FROM sales s
WHERE s.invoice_number = invoiceNum;

END
$$;

-- Test that it works
CALL return_vehicle('1362717835');
SELECT * FROM sales WHERE invoice_number = '1362717835';
SELECT * FROM vehicles WHERE vehicle_id = (SELECT vehicle_id FROM sales WHERE invoice_number = '1362717835');
SELECT * FROM oilchangelog WHERE vehicle_id = (SELECT vehicle_id FROM sales WHERE invoice_number = '1362717835');

