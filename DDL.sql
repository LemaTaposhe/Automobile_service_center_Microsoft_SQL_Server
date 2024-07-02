use master 
go
If DB_ID ('AutomobileServiceCenter') is not null
drop database AutomobileServiceCenter
go

 sp_helpdb master 
 go



---==============================================================================================
----------------------Create database With custom properties-------------------------------
--================================================================================================
Declare @data_path nvarchar(256) 

Set @data_path = (Select SUBSTRING(Physical_name,1,CHARINDEX(N'master.mdf',LOWER(Physical_name))-1)
From master.sys.master_files 
Where database_id=1 and file_id=1);
Execute('create Database AutomobileServiceCenter on primary(Name=AutomobileServiceCenter_data,FILENAME=''' + @data_path + 'AutomobileServiceCenter_data.mdf'',size=30MB, Maxsize=Unlimited,Filegrowth=20%) 
log on(Name=AutomobileServiceCenter_log,FileName=''' +@data_path+ 'AutomobileServiceCenter_log.ldf'',size=10MB, Maxsize=100MB,Filegrowth=1MB)'
)

GO


sp_helpdb AutomobileServiceCenter
Go

Use AutomobileServiceCenter
GO
---==============================================================================================
---                     Create Schema
---==============================================================================================

Create schema amobi
GO
---==============================================================================================
----                   Create customer Table
---==============================================================================================

Use AutomobileServiceCenter
Create TABLE amobi.Customers 
(
  Customer_id INT PRIMARY KEY Identity ,
  Customer_name VARCHAR(255) NOT NULL,
  Customer_Photo VARBINARY(300),
  Email VARCHAR(255) NOT NULL,
  Opt_in_email BIT,
  Phone_number bigint NOT NULL,
  Address VARCHAR(255) NOT NULL
)
GO


---==============================================================================================
----                   Create Vehicles TABLE---
---==============================================================================================


Use AutomobileServiceCenter
CREATE TABLE amobi.Vehicles 
(
  Vehicle_id INT PRIMARY KEY Identity,
  License_plate VARCHAR(255) NOT NULL,
  Vehicle_make VARCHAR(255) NOT NULL,
  Vehicle_model VARCHAR(255) NOT NULL,
  Vehicle_age tinyint NOT NULL,
  Customer_id INT FOREIGN KEY REFERENCES amobi.Customers(Customer_id) NOT NULL
)
GO


---==============================================================================================
---                        Create Services  Table
---==============================================================================================

Use AutomobileServiceCenter
CREATE TABLE amobi.Services
(
  Service_id INT PRIMARY KEY Identity,
  Service_name VARCHAR(255) NOT NULL,
  Service_description VARCHAR(255) NOT NULL,
  Service_price DECIMAL(10,2) NOT NULL
)
GO


---==============================================================================================
----                          Create Departments  Table
---==============================================================================================
Use AutomobileServiceCenter
CREATE TABLE amobi.Departments 
(
    Department_id smallint PRIMARY KEY Identity,
    Department_name VARCHAR(255) NOT NULL
)
GO
---==============================================================================================
---                          Create Employee Table
---==============================================================================================


Use AutomobileServiceCenter
CREATE TABLE amobi.Employees
(
    Employee_id INT PRIMARY KEY,
    Employee_name VARCHAR(50) NOT NULL,
    Phone_number bigint NOT NULL,
	Employee_address ntext null,
    Department_id smallint Foreign key references amobi.Departments(Department_id) Not null,
	Salary Money,
    Worker_type VARCHAR(20) NOT NULL,
    Worker_specialization VARCHAR(50)
)

GO


---==============================================================================================
---                       Create Table Appointments 
---==============================================================================================


Use AutomobileServiceCenter
CREATE TABLE amobi.Appointments 
(
    Appointment_id INT PRIMARY KEY Identity,
	Customer_id INT Foreign key references amobi.Customers(Customer_id) Not null,
    Appointment_date DATE NOT NULL,
    Appointment_time TIME NOT NULL,
    Appointment_status VARCHAR(20) not null,
    Appointment_notes text 
)
GO



---==============================================================================================
----                      Create  Table AppDetails 
---==============================================================================================



Use AutomobileServiceCenter
CREATE TABLE amobi.AppDetails
(
  AppDetails_id INT IDENTITY(1,1) PRIMARY KEY,
  Appointment_id int Foreign key references amobi.Appointments(Appointment_id) Not null,
  Vehicle_id  INT  foreign key references amobi.Vehicles(Vehicle_id) Not null

)

go



---==============================================================================================
---                     Create Table Service Records 
---==============================================================================================



Use AutomobileServiceCenter
CREATE TABLE amobi.ServiceRecords
(
 ServiceRecord_id   INT PRIMARY KEY Identity,
 Appointment_id	 INT Foreign key references amobi.Appointments(Appointment_id) Not Null,                   
 ServicePerformed_Date   Datetime Not Null,
 Total_Bill DECIMAL(10,2) Not Null,
 Service_Status  VARCHAR(255)
)
GO


---==============================================================================================
---                          Create Table Service details 
---==============================================================================================


Use AutomobileServiceCenter
CREATE TABLE amobi.ServiceDetails
(
 ServiceDetail_id INT PRIMARY KEY Identity,
 ServiceRecord_id INT Foreign key references amobi.ServiceRecords(ServiceRecord_id) not null,
 Service_id INT Foreign key references amobi.Services(Service_id)Not null,
 Service_Price DECIMAL(10,2) not null,
 Employee_id INT Foreign key references amobi.Employees(Employee_id)Not null
)
go

---==============================================================================================
  ---                    Create Table PromotionalOffers 
---==============================================================================================


Create TABLE amobi.PromotionalOffers 
 (
  PromotionalOffer_id INT Primary key Identity,
  Offer_name VARCHAR(255) NOT NULL,
  Offer_description VARCHAR(255) NOT NULL,
  Start_date DATE NOT NULL,
  End_date DATE NOT NULL,
  Discount_Percentage DECIMAL(10,2) NOT NULL,
  Minimum_Service_Amount DECIMAL(10,2) NOT NULL
)
Go


---==============================================================================================
--                           Create Table Invoice 
---==============================================================================================
Create TABLE amobi.Invoices 
(
    Invoice_id INT PRIMARY KEY NOT NULL ,
    Customer_id INT FOREIGN KEY REFERENCES amobi.Customers (Customer_id) NOT NULL,
    Appointment_id INT FOREIGN KEY REFERENCES amobi.Appointments(Appointment_id) NOT NULL,
    ServiceRecord_id INT FOREIGN KEY REFERENCES amobi.ServiceRecords (ServiceRecord_id) NOT NULL,
    Quantity INT NOT NULL,
    Total_price DECIMAL(10,2) NOT NULL,
	PromotionalOffer_id INT FOREIGN KEY REFERENCES amobi.PromotionalOffers (PromotionalOffer_id),
    Discount_Percentage DECIMAL(10,2)not null,
    Grand_Total DECIMAL(10,2) NOT NULL,
    Payment_Status VARCHAR(255) NOT NULL
  )
  go



---==============================================================================================
--                    Create  Procedure
---==============================================================================================


CREATE PROCEDURE amobi.InsertUpdate_invoices 
(
  @invoice_id INT,
  @customer_id INT,
  @appointment_id INT,
  @servicerecord_id INT,
  @quantity INT,
  @total_price DECIMAL(10,2),
  @promotionaloffer_id INT,
  @discount_percentage DECIMAL(10,2),
  @payment_status VARCHAR(255)
)
AS
BEGIN
  -- Calculate the grand total
  DECLARE @grand_total DECIMAL(10,2);
  SET @grand_total = @total_price - (@discount_percentage / 100) * @total_price;

  -- Check if the invoice exists
  IF EXISTS (SELECT 1 FROM amobi.invoices WHERE Invoice_id = @invoice_id)
  BEGIN
    -- Update the invoice
    UPDATE amobi.Invoices
    SET Customer_id = @customer_id,
        Appointment_id = @appointment_id,
        ServiceRecord_id = @servicerecord_id,
        Quantity = @quantity,
        Total_price = @total_price,
        PromotionalOffer_id = @promotionaloffer_id,
        Discount_percentage = @discount_percentage,
        Grand_total = @grand_total,
        Payment_status = @payment_status
    WHERE Invoice_id = @invoice_id;
  END
  ELSE
  BEGIN
    -- Insert the new invoice
    INSERT INTO amobi.Invoices 
	(
      Invoice_id,
      Customer_id,
      Appointment_id,
      ServiceRecord_id,
      Quantity,
      Total_price,
      PromotionalOffer_id,
      Discount_Percentage,
      Grand_Total,
      Payment_Status
    )
    VALUES (@invoice_id, @customer_id, @appointment_id, @servicerecord_id, @quantity, @total_price, @promotionaloffer_id, @discount_percentage, @grand_total, @payment_status);
  END
END
go
----===EXECUTE Procedure====----
--EXEC amobi.InsertUpdate_invoices  1,1,1,1,2,4200,null,0,'Paid'
--go
--=========================================================================================================
--                    Create  Table   Discount 
--=========================================================================================================

Create TABLE amobi.discounts 
(
    discount_id Smallint NOT NULL ,
    customer_id int not null,
    service_id INT Not null,
    discount_percentage Real NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL
)
go
--=========================================================================================================
---                           Create index
--=========================================================================================================
CREATE INDEX discounts_customer_id_idx ON amobi.discounts (customer_id)
go
--=========================================================================================================
--                           Drop index
--=========================================================================================================
Drop INDEX discounts_customer_id_idx ON amobi.discounts
go

--=========================================================================================================
---                     CREATE CLUSTERED INDEX
--=========================================================================================================

CREATE CLUSTERED INDEX index_discounts_id
ON amobi.discounts  (discount_id)
go

--=========================================================================================================
---                      CREATE NonCLUSTERED INDEX
--=========================================================================================================
CREATE NONCLUSTERED INDEX Index_discounts ON amobi.discounts (discount_id) 
go
--=========================================================================================================
--                          ALTER TABLE 
--=========================================================================================================

ALTER TABLE amobi.discounts DROP COLUMN  created_at
go

--=========================================================================================================
--                           TRUNCATE TABLE
--=========================================================================================================

TRUNCATE TABLE amobi.discounts
go

--=========================================================================================================
--                          Drop table
--=========================================================================================================
Drop table amobi.discounts
go


--=========================================================================================================
--                            Example of catalo View
--=========================================================================================================


SELECT sys.tables.name AS TableName, sys.schemas.name AS SchemaName
FROM sys.tables INNER
 
JOIN sys.schemas
ON sys.tables.schema_id = sys.schemas.schema_id

--[ Note:Here some cataloge view name: sys.schemas, sys.seqyances,sys.objects, sys.tables, sys.views
--- sys.columns, sys.key_constraints, sys.foreign_keys, sys.foreign_key_columns ] 



go

--=========================================================================================================
--                            Create View
--=========================================================================================================

Create VIEW amobi.ActiveVehicles AS
SELECT v.vehicle_id, v.license_plate, v.vehicle_make, v.vehicle_model, v.vehicle_age, v.customer_id
FROM amobi.Vehicles v
WHERE v.vehicle_age <= 2
go

--=========================================================================================================
--                            select view
--=========================================================================================================
SELECT *
FROM amobi.ActiveVehicles
GO
--=========================================================================================================
--                           WITH SCHEMABINDING view
--=========================================================================================================

CREATE VIEW amobi.vw_CustomerVehicles 
WITH SCHEMABINDING
AS
SELECT c.Customer_id, c.Customer_name, v.License_plate, v.Vehicle_make, v.Vehicle_model
FROM amobi.Customers c
INNER JOIN amobi.Vehicles v ON c.Customer_id = v.Customer_id
go


--=========================================================================================================
--                           Drop SCHEMABINDING view
--=========================================================================================================
Drop VIEW amobi.vw_CustomerVehicles 
Go



--=========================================================================================================
--                           WITH Encryption  view
--=========================================================================================================
CREATE VIEW amobi.vw_CustomerAppointments
WITH ENCRYPTION 

As
SELECT c.Customer_id, c.Customer_name, a.Appointment_date, a.Appointment_time, a.Appointment_status
FROM amobi.Customers c
INNER JOIN amobi.Appointments a ON c.Customer_id = a.Customer_id
WITH CHECK OPTION
go
--------------------------Drop------------------------------------------
Drop VIEW amobi.vw_CustomerAppointments 
Go

--=========================================================================================================
--                     CREATE PROCEDURE InsertAppointment
--=========================================================================================================

Use AutomobileServiceCenter
go


Create PROCEDURE amobi.sp_InsertAppointment
(
    @customer_id INT,
    @appointment_date DATE,
    @appointment_time TIME,
    @appointment_status VARCHAR(20),
    @appointment_notes TEXT
)
AS
BEGIN
    INSERT INTO amobi.Appointments
    (
        Customer_id,
        Appointment_date,
        Appointment_time,
        Appointment_status,
        Appointment_notes
    )
    VALUES
    (
        @customer_id,
        @appointment_date,
        @appointment_time,
        @appointment_status,
        @appointment_notes
    )
END
GO
--=========================================================================================================
----                EXEC PROCEDURE InsertAppointment
--=========================================================================================================
EXEC amobi.sp_InsertAppointment 3, '2023-11-11', '10:00:00 AM', 'Scheduled', 'Oil change'
GO

--=========================================================================================================
---                CREATE FUNCTION
--=========================================================================================================
Create FUNCTION amobi.fn_GetTotalServiceCharges(@appointment_id INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
  DECLARE @total_charges DECIMAL(10,2)
  SELECT @total_charges = SUM(Service_price)
  FROM amobi.ServiceDetails
  INNER JOIN amobi.ServiceRecords ON amobi.ServiceDetails.ServiceRecord_id = amobi.ServiceRecords.ServiceRecord_id
  WHERE amobi.ServiceRecords.Appointment_id = @appointment_id
  RETURN @total_charges;
END
go

--=========================================================================================================
---            Check FUNCTION
--=========================================================================================================



SELECT  SUM(amobi.fn_GetTotalServiceCharges(Appointment_id)) AS total_service_charges
FROM amobi.Appointments
WHERE Appointment_date >= DATEADD(MONTH, -1, GETDATE())

Go

--=========================================================================================================
---             Drop FUNCTION 
--=========================================================================================================


Drop FUNCTION amobi.fn_GetTotalServiceCharges
GO



--==================================================================================================
---------------------CREATE  SCALAR  FUNCTION CalculateTotalBill------------------------------------
--===================================================================================================



CREATE FUNCTION amobi.fn_CalculateTotalBill
(
    @servicerecord_id INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total_bill DECIMAL(10,2)

    SELECT @total_bill = SUM(Service_price)
    FROM amobi.ServiceDetails 
    WHERE ServiceRecord_id = @servicerecord_id

    RETURN @total_bill
END
Go
--==================================================================================================
-----               CHECK  SCALAR  FUNCTION CalculateTotalBill
--===================================================================================================
SELECT amobi.fn_CalculateTotalBill(1)
GO

--==================================================================================================
---                 Create  Tabler  FUNCTION CalculateTotalBill
--===================================================================================================

CREATE FUNCTION fn_customerdetails
(@customer_id INT)
RETURNS TABLE AS

    RETURN (
        SELECT
            Customer_id   ,
            Customer_name ,
            Email ,
            Opt_in_email,
            Phone_number ,
            Address 
            FROM amobi.Customers 
           WHERE Customer_id = @customer_id
    );

go
--==================================================================================================
---                 CHECK  Tabler  FUNCTION CalculateTotalBill
--===================================================================================================

DECLARE @customer_id INT = 1;
SELECT * FROM fn_customerdetails (@customer_id)
go



--==================================================================================================
---                 Create Table for Trigger 
--===================================================================================================

CREATE TABLE amobi.Services_Audit
(
  Audit_Id int primary key identity,
  Service_id INT,
  Service_name VARCHAR(255) NOT NULL,
  Service_description VARCHAR(255) ,
  Service_price DECIMAL(10,2) NOT NULL,
  actionname varchar (30),
  actionTime datetime
)
go


--==================================================================================================
---               --Combined after trigger 
--===================================================================================================

create Trigger After_combined_trigger on amobi.Services
After Insert, update, delete
As
Declare @audit_Id int,@service_id int,@service_name varchar(255),@service_description varchar(255),@service_price DECIMAL(10,2),@actionname varchar (30),@actionTime datetime
select @service_id= i. Service_id   from inserted i
select @service_name= i.Service_name  from inserted i
select @service_description= i.Service_description  from inserted i
select @service_price= i.Service_price  from inserted i
set @actionname=' After insert,update,delete Trigger '
insert into amobi.Services_Audit values(@service_id,@service_name,@service_description,@service_price,@actionname,GETDATE())
Print 'After insert,update,delete Trigger just Fired!!!!!'
go


--==================================================================================================
---                      Combined instead of Trigger
--============================================================================================
create Trigger Combined_insteadof_trigger on amobi.Services
instead of insert,update, delete
As
Begin 
IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
Declare @audit_Id int,@service_id int,@service_name varchar(255),@service_description varchar(255),@service_price DECIMAL(10,2),@actionname varchar (30),@actionTime datetime
select @service_id= i. Service_id   from inserted i
select @service_name= i.Service_name  from inserted i
select @service_description= i.Service_description  from inserted i
select @service_price= i.Service_price  from inserted i
set @actionname=' instead of insert Trigger '
insert into amobi.Services_Audit values(@service_id,@service_name,@service_description,@service_price,@actionname,GETDATE())
Print 'instead of insert Trigger just Fired!!!!!'
end 

IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
BEGIN
Declare @audit_Id2 int,@service_id2 int,@service_name2 varchar(255),@service_description2 varchar(255),@service_price2 DECIMAL(10,2),@actionname2 varchar (30),@actionTime2 datetime
select @service_id2= i. Service_id   from inserted i
select @service_name2= i.Service_name  from inserted i
select @service_description2= i.Service_description  from inserted i
select @service_price2= i.Service_price  from inserted i
set @actionname2=' instead of update Trigger '
insert into amobi.Services_Audit values(@service_id2,@service_name2,@service_description2,@service_price2,@actionname2,GETDATE())
Print 'instead of update Trigger just Fired!!!!!'
end

ELSE IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
	Declare @audit_Id3 int,@service_id3 int,@service_name3 varchar(255),@service_description3 varchar(255),@service_price3 DECIMAL(10,2),@actionname3 varchar (30),@actionTime3 datetime
select @service_id2= i. Service_id   from inserted i
select @service_name3= i.Service_name  from inserted i
select @service_description3= i.Service_description  from inserted i
select @service_price3= i.Service_price  from inserted i
set @actionname3=' instead of delete Trigger '
insert into amobi.Services_Audit values(@service_id3,@service_name3,@service_description3,@service_price3,@actionname3,GETDATE())
Print 'instead of delete Trigger just Fired!!!!!'
    end
end