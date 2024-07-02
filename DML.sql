Use AutomobileServiceCenter
GO

--=========================================================================================================
------                        Insert amobi.Customers 
--=========================================================================================================
Use AutomobileServiceCenter
GO
INSERT INTO amobi.Customers (Customer_name, Customer_Photo, Email, Opt_in_email, Phone_number, Address)
VALUES
('MD Rahaman', NULL, 'rahaman@example.com', 1, 145632378, '123 Golden Street,  CA 12345'),
('MR Shen', NULL, 'shen@example.com', 1, 187434461, '456 Old Street, CA 12345'),
('MD Khan', NULL, 'khan@example.com', 0, 155456612, '789 New Town, CA 12345')
GO

--=========================================================================================================
---                            Insert amobi.Vehicles
--=========================================================================================================
Use AutomobileServiceCenter
GO
INSERT INTO amobi.Vehicles
VALUES
('ABC123', 'Acura', 'MDX', 2,1),
('DEF456', 'Alfa Romeo', 'Giulia', 3,2),
('GHI789', 'Toyota', 'Camry', 5, 1)
go


--=========================================================================================================
--                      insert amobi.Services 
--=========================================================================================================

Use AutomobileServiceCenter
GO
INSERT INTO amobi.Services (Service_name, Service_description, Service_price)
VALUES
  ('Oil change', 'Replaces the old oil in your car with new oil.', 1100.00),
  ('Tire rotation', 'Moves the tires from one wheel to another to help them wear more evenly.', 2500.00),
  ('Brake inspection', 'Inspects the brake pads and rotors to make sure they are in good condition.', 5000.00),
  ('Engine tune-up', 'Adjusts the engine timing and spark plugs to improve performance and fuel economy.', 1200.00),
  ('Transmission fluid change', 'Replaces the old transmission fluid with new fluid to keep the transmission running smoothly.', 1500.00),
  ('Wheel alignment', 'Aligns the wheels so that they are perpendicular to the ground and parallel to each other. This helps to improve fuel economy and tire life.', 3100.00),
  ('Air conditioning service', 'Checks the air conditioning system for leaks and recharges the refrigerant as needed.', 5000.00),
  ('Battery test', 'Tests the battery to make sure it is still holding a charge.', 5025.00),
  ('Car wash', 'Washes and vacuums the car interior and exterior.', 1000.00),
  ('Detailing', 'Thoroughly cleans and polishes the car interior and exterior.', 5100.00),
  ('Windshield replacement', 'Replaces a cracked or damaged windshield.', 3000.00),
  ('Brake repair', 'Repairs or replaces brake pads, rotors, and calipers as needed.', 5200.00),
  ('Engine repair', 'Repairs or replaces engine components as needed.', 5500.00),
  ('Transmission repair', 'Repairs or replaces transmission components as needed.', 5500.00),
  ('Suspension repair', 'Repairs or replaces suspension components as needed.', 2000.00)



--=========================================================================================================
--                                  Insert amobi.Departments
--=========================================================================================================
Use AutomobileServiceCenter
GO
INSERT INTO amobi.Departments (Department_name)
VALUES
    ('Mechanics'),
    ('Service Advisors'),
    ('Cashiers'),
    ('Managers')

--=========================================================================================================
--                    Insert  amobi.Employees 
--=========================================================================================================
Use AutomobileServiceCenter
GO
INSERT INTO amobi.Employees (Employee_id, Employee_name, Phone_number, Employee_address, Department_id, Salary, Worker_type, Worker_specialization)
VALUES
    (1, 'MD Kamal', 1234567890, '123 Main Street, Anytown, CA 91234', 1, 30000, 'Mechanic', 'Engine repair'),
	 (2, 'MD Salam', 1234567890, '123 Rose Street, Anytown, CA 91223', 1, 20000, 'Mechanic', 'General worker'),
    (3, 'MD Rofiq', 9876543210, '456 Elm Street, Anytown, LA 91234', 2, 45000, 'Service Advisor', 'Customer service'),
    (4, 'MD Jamal', 1122334455, '789 Oak Street, Anytown, NC 91234', 3, 35000, 'Cashier', 'Cash handling'),
    (5, 'MD Mannan', 6789012345, '12345 Maple Street, Anytown, KI 91234', 4, 60000, 'Manager', 'Overall management')

--=========================================================================================================
--                             Appointments table
--=========================================================================================================
Use AutomobileServiceCenter
GO
INSERT INTO amobi.Appointments
(Customer_id, Appointment_date, Appointment_time, Appointment_status, Appointment_notes)
VALUES
(1, '2023-11-11', '10:00 AM', 'Scheduled', 'Oil change , Wheel alignment'),
(2, '2023-11-12', '11:00 AM', 'Scheduled', 'Tire rotation,Car wash')

--=========================================================================================================
--                        Appointment details table 
--=========================================================================================================
Use AutomobileServiceCenter
GO
INSERT INTO amobi.AppDetails
(Appointment_id, Vehicle_id)
VALUES
(1, 1),
(2, 2)

--=========================================================================================================
--                        Service records table 
--=========================================================================================================
Use AutomobileServiceCenter
GO
INSERT INTO amobi.ServiceRecords
(Appointment_id, ServicePerformed_Date, Total_Bill,  Service_Status)
VALUES
(1, '2023-11-11', 4200.00, 'Completed'),
(2, '2023-11-12', 3500.00, 'Scheduled')

--=========================================================================================================
--                             Service details table
--=========================================================================================================
Use AutomobileServiceCenter
GO
INSERT INTO amobi.ServiceDetails
(ServiceRecord_id, Service_id, Service_Price , Employee_id)

VALUES
(1, 1,2500.00, 1),
(1, 6, 3100.00,2),
(2, 2, 2500.00, 2),
(2, 9, 1000.00,1)
go


--=========================================================================================================
------                           promotional_offers
--=========================================================================================================
Use AutomobileServiceCenter
GO
INSERT INTO amobi.PromotionalOffers (Offer_name, Offer_description, Start_date, End_date, Discount_Percentage, Minimum_Service_Amount)
VALUES
  ('Summer Car Service Discount', 'Get 20% off your next car service', '2023-08-01', '2023-09-01', 0.2, 20000),
  ('New Customer Discount', 'Get 10% off your first car service', '2023-11-12', '2023-11-30', 0.1, 10000)
  go

--=========================================================================================================
----                    EXECUTE Insert Invoice By Procedure
--=========================================================================================================
Use AutomobileServiceCenter
GO
EXEC amobi.InsertUpdate_invoices  1,1,1,1,2,4200,null,0,'Paid'



--=========================================================================================================
---                            Discounts table
--=========================================================================================================
Use AutomobileServiceCenter
GO
INSERT INTO amobi.discounts
VALUES
(1, 1, 00.00, '2023-11-10', '2023-11-10')
go

--=========================================================================================================
--                            DML(SELECT)
--=========================================================================================================v
Use AutomobileServiceCenter
GO


SELECT * FROM  amobi.Customers 
SELECT * FROM amobi.Vehicles 
SELECT * FROM amobi.Services
SELECT * FROM amobi.Departments 
SELECT * FROM  amobi.Employees
SELECT * FROM amobi.Appointments
SELECT * FROM amobi.ServiceRecords
SELECT * FROM amobi.ServiceDetails
SELECT * FROM amobi.PromotionalOffers 
SELECT * FROM amobi.Invoices 

Go
--=========================================================================================================
---                               Update
--=========================================================================================================
Use AutomobileServiceCenter
GO
-- Update a customer's email address in the customers table
UPDATE amobi.Customers SET Email = 'mdrahaman@example.com' WHERE Customer_id = 1
go
--=========================================================================================================
----                            Delete
--=========================================================================================================
Use AutomobileServiceCenter
GO
Delete
From  amobi.PromotionalOffers
Where  PromotionalOffer_id=2
Go

--=========================================================================================================
----                Where Cndition
--=========================================================================================================
SELECT *
FROM amobi.Customers
WHERE Customer_name = 'MR Shen' AND Customer_id < 100

--=========================================================================================================
----                Group By    
--=========================================================================================================
SELECT ServicePerformed_Date, SUM(Total_Bill) AS Total_bill
FROM amobi.ServiceRecords
GROUP BY ServicePerformed_Date
go


--=========================================================================================================
----                Having  
--=========================================================================================================
SELECT service_name, service_price, COUNT(*) AS num_Services
FROM amobi.Services
GROUP BY service_name, service_price
HAVING COUNT(*) < 15


--=========================================================================================================
----                Order By    +  DESC
--=========================================================================================================
SELECT *
FROM amobi.Invoices
ORDER BY Total_price DESC



--=========================================================================================================
----                            Inner Join
--=========================================================================================================
Use AutomobileServiceCenter
GO
SELECT Employee_name, Department_name
FROM amobi.Employees e
INNER JOIN amobi.Departments d
ON e.Department_id = d.Department_id
--=========================================================================================================
----                            LEFT OUTER JOIN
--=========================================================================================================
Use AutomobileServiceCenter
GO
SELECT c.Customer_name, c.Email, v.License_plate, v.Vehicle_make, v.Vehicle_model
FROM amobi.Customers c
LEFT OUTER JOIN amobi.Vehicles v
ON c.Customer_id = v.Customer_id

go
--=========================================================================================================
----                            RIGHT OUTER JOIN
--=========================================================================================================
Use AutomobileServiceCenter
GO
SELECT c.Customer_name, c.Email, v.License_plate, v.Vehicle_make, v.Vehicle_model
FROM amobi.Vehicles v
RIGHT OUTER JOIN amobi.Customers c
ON v.Customer_id = c.Customer_id

go

--=========================================================================================================
----                            FULL OUTER JOIN
--=========================================================================================================
Use AutomobileServiceCenter
GO

SELECT c.Customer_name, c.Email, v.License_plate, v.Vehicle_make, v.Vehicle_model
FROM amobi.Customers c
FULL OUTER JOIN amobi.Vehicles v
ON c.Customer_id = v.Customer_id
go


--=========================================================================================================
----                            CROSS JOIN
--=========================================================================================================
Use AutomobileServiceCenter
GO

SELECT c.Customer_name, v.License_plate
FROM amobi.Customers c
CROSS JOIN amobi.Vehicles v
go

--=========================================================================================================
----                            Query  List all service records and the total bill amount
--=========================================================================================================
Use AutomobileServiceCenter
GO
SELECT ServiceRecord_id, ServicePerformed_Date, Total_Bill
FROM amobi.ServiceRecords
go
--=========================================================================================================
----                            Concatenate string Data
--=========================================================================================================
Use AutomobileServiceCenter
GO
Select Employee_name, Worker_type, Employee_name + Worker_type
From amobi.Employees
go

--=========================================================================================================
----                             string Data using literal Values
--=========================================================================================================
Use AutomobileServiceCenter
GO
Select Employee_id,

Employee_name +', '+ Worker_type 
From amobi.Employees
go

--=========================================================================================================
----                             string Data including apstrophes in literal Values
--=========================================================================================================
Use AutomobileServiceCenter
GO
Select Employee_name +'''s Specialization: ' ,

Employee_name +', '+ Worker_specialization
From amobi.Employees;
go

--=========================================================================================================
----                           CTE
--=========================================================================================================
WITH Customers AS (
  SELECT *
  FROM amobi.Customers
),
Vehicles AS (
  SELECT *
  FROM amobi.Vehicles
),
Appointments AS (
  SELECT *
  FROM amobi.Appointments
)
SELECT c.Customer_name, c.Email, v.License_plate, v.Vehicle_make, v.Vehicle_model, a.Appointment_date
FROM Customers c
JOIN Vehicles v ON c.Customer_id = v.Customer_id
JOIN Appointments a ON c.Customer_id = a.Customer_id
WHERE a.Appointment_date > '2023-11-10'
AND v.Vehicle_age > 2

Go


--=========================================================================================================
----                Correlated subquery           
--=========================================================================================================
SELECT c.Customer_name, v.License_plate, a.Appointment_date, a.Appointment_time
FROM amobi.Customers c
JOIN amobi.Vehicles v ON c.Customer_id = v.Customer_id
JOIN amobi.Appointments a ON c.Customer_id = a.Customer_id
WHERE a.Appointment_id = (
    SELECT MAX(a2.Appointment_id)
    FROM amobi.Appointments a2
    WHERE a2.Customer_id = c.Customer_id
)
GO

--=========================================================================================================
----                ROLLUP         
--=========================================================================================================
SELECT Service_name, SUM(Service_price) AS Total_service_price
FROM amobi.Services
GROUP BY Service_name
WITH ROLLUP
GO


--=========================================================================================================
----                CUBE         
--=========================================================================================================
SELECT Service_name, SUM(Service_price) AS Total_service_price
FROM amobi.Services
GROUP BY Service_name
WITH CUBE 
Go

--=========================================================================================================
--  CAST  function
--=========================================================================================================
SELECT CAST('2019-June-01 10:00 AM' AS datetime)
GO
--=========================================================================================================
--   CONVERT function
--=========================================================================================================
SELECT CONVERT(TIME,'01-June-2019 10:00AM',108)
GO