-- Start a transaction
START TRANSACTION;

-- Get the new order number
SELECT MAX(orderNumber) + 1 AS newOrderNumber FROM orders;
SELECT @newOrderNumber := MAX(orderNumber) + 1 FROM orders;

-- Insert a new order
INSERT INTO orders 
VALUES (@newOrderNumber, NOW(), DATE_ADD(NOW(), INTERVAL 5 DAY), DATE_ADD(NOW(), INTERVAL 2 DAY), 'in process', NULL, 145);

-- Insert order details
INSERT INTO orderdetails 
VALUES 
(@newOrderNumber, 'S18_1749', '30', '136', '1'),
(@newOrderNumber, 'S18_2248', '50', '55.09', '2');

-- Commit the transaction
COMMIT;

-- Drop the procedure if it exists
DROP PROCEDURE IF EXISTS setRelocationFee;

-- Create the setRelocationFee procedure
DELIMITER $$
CREATE PROCEDURE setRelocationFee(IN employeeid INT, OUT relocationfee INT)
BEGIN
    SELECT city 
    INTO @newCity 
    FROM offices
    WHERE officeCode IN 
        (SELECT officeCode FROM employees WHERE employeeNumber = employeeid);
        
    IF @newCity = 'San Francisco' THEN 
        SET relocationfee = 10000; 
    ELSEIF @newCity = 'Boston' THEN 
        SET relocationfee = 8000; 
    ELSEIF @newCity = 'London' THEN 
        SET relocationfee = 20000; 
    ELSE 
        SET relocationfee = 15000; -- if all fails
    END IF;
END$$
DELIMITER ;

-- Drop the procedure if it exists
DROP PROCEDURE IF EXISTS changeCreditLimit;

-- Create the changeCreditLimit procedure
DELIMITER $$
CREATE PROCEDURE changeCreditLimit(IN customer INT, IN totalpayment INT)
BEGIN
    SELECT SUM(amount) 
    INTO @totalVal 
    FROM payments 
    WHERE customerNumber = customer;
    
    IF @totalVal >= 2000 THEN 
        UPDATE customers 
        SET creditLimit = creditLimit + 2000;
    END IF;
END$$
DELIMITER ;

-- Create the odd table
CREATE TABLE odd (
    number INT PRIMARY KEY
);

-- Drop the procedure if it exists
DROP PROCEDURE IF EXISTS insertOdd;

-- Create the insertOdd procedure
DELIMITER $$
CREATE PROCEDURE insertOdd()
BEGIN
    SET @counter := 1; -- starting value
    
    WHILE @counter <= 20 DO
        IF @counter != 5 AND @counter != 15 THEN 
            INSERT INTO odd VALUES(@counter);
        END IF;
        SET @counter = @counter + 2;
    END WHILE;
END$$
DELIMITER ;
