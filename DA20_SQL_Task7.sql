
-- Creating 2 ENUM


-- 1. Creating Table With ENUM

CREATE TYPE payment_method_type AS ENUM ('cash', 'credit_card', 'debit_card', 'paypal', 'bank_transfer');

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    product_name VARCHAR(100),
    quantity INT,
    order_date DATE,
    payment_method payment_method_type
);

--Inserting Values

INSERT INTO orders (customer_name, product_name, quantity, order_date, payment_method)
VALUES 
('Aman', 'Laptop', 1, '2025-08-01', 'credit_card'),
('Rohit', 'Smartphone', 2, '2025-08-02', 'paypal');



-- 2. Adding ENUM Using Alter

CREATE TYPE shipping_method_type AS ENUM ('standard', 'express', 'overnight', 'pickup');

ALTER TABLE orders
ADD COLUMN shipping_method shipping_method_type;

INSERT INTO orders (customer_name, product_name, quantity, order_date, payment_method, shipping_method)
VALUES
('Shaam', 'Keyboard', 5, '2025-08-04', 'cash', 'standard');



-----------------------------------------------------------------------------------------------------------------

-- Creating 3 Domain 


-- 1. For order_date is not before the year 2000

CREATE DOMAIN order_date_type AS DATE
CHECK (VALUE >= DATE '2000-01-01');


ALTER TABLE orders
ALTER COLUMN order_date TYPE order_date_type;


-- 2. Domain to allow only alphabetic characters and spaces 

CREATE DOMAIN customer_name_type AS VARCHAR(100)
CHECK (VALUE ~ '^[A-Za-z ]+$');

ALTER TABLE orders
ALTER COLUMN customer_name TYPE customer_name_type;


-- 3. Domain for quantity positive and greater then 0 integer only

CREATE DOMAIN quantity_type AS INT
CHECK (VALUE > 0);

ALTER TABLE orders
ALTER COLUMN quantity TYPE quantity_type;


-----------------------------------------------------------------------------------------------------------------

--Create User Define Function With Multiif Statement 

CREATE OR REPLACE FUNCTION get_order_priority(quantity INT)
RETURNS TEXT AS $$
DECLARE
    order_priority TEXT;
BEGIN
    IF quantity >= 100 THEN
        order_priority := 'Very High';
    ELSIF quantity >= 75 THEN
        order_priority := 'High';
    ELSIF quantity >= 50 THEN
        order_priority := 'Medium';
    ELSIF quantity >= 25 THEN
        order_priority := 'Low';
    ELSE
        order_priority := 'Very Low';
    END IF;

    RETURN order_priority;
END;
$$ LANGUAGE plpgsql;



SELECT order_id, customer_name, quantity, get_order_priority(quantity) AS priority_level
FROM orders;

-- Adding Priorty as Column in Orders Table

ALTER TABLE orders ADD COLUMN order_priority TEXT;

UPDATE orders
SET order_priority = get_order_priority(quantity);

SELECT * FROM orders;

-----------------------------------------------------------------------------------------------------------------