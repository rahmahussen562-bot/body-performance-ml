-- Create Database 
CREATE DATABASE HotelReservation_BillingManagement;
--Create Tables for Hotel Reservation and Billing Management System

--1_ Employee Table
--"This table serves as the core HR and Operational backbone of the system. 
--It is designed to manage and track all hotel staff involved in the reservation and billing lifecycle.
--From a Data Analysis perspective, this table allows for workforce distribution modeling, 
--identifying key operational roles (like Receptionists and Billing Managers), 
--and analyzing staff demographics to optimize hotel management efficiency."

CREATE TABLE Employee (           
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmpName VARCHAR(100) NOT NULL,
    JobRole VARCHAR(50) NOT NULL, 
    hiring_Date DATETIME DEFAULT GETDATE(),
    Gender VARCHAR(10),
    SSN VARCHAR(20) UNIQUE,
    Marital_Status VARCHAR(20)
);
CREATE NONCLUSTERED INDEX IX_Employees_JobRole
ON Employee (JobRole);

CREATE NONCLUSTERED INDEX IX_Employees_SSN
ON Employee (SSN);

INSERT INTO Employee (EmpName, JobRole, Gender, SSN, Marital_Status) VALUES
('Ahmed Ali', 'Receptionist', 'Male', 'SSN01', 'Single'), 
('Sara Ahmed', 'Receptionist', 'Female', 'SSN02', 'Married'),
('Mona Zaki', 'Billing Manager', 'Female', 'SSN03', 'Single'),
('Hany Amr', 'Housekeeping', 'Male', 'SSN04', 'Married'),
('Ziad Aly', 'Housekeeping', 'Male', 'SSN05', 'Single'),
('Laila Nour', 'Receptionist', 'Female', 'SSN06', 'Single'),
('Omar Saad', 'Billing Manager', 'Male', 'SSN07', 'Married'),
('Noha Adel', 'Housekeeping', 'Female', 'SSN08', 'Single'),
('Karem Gad', 'Receptionist', 'Male', 'SSN09', 'Married'), 
('Maya Ihab', 'Admin', 'Female', 'SSN10', 'Single'),
('Fady Aly', 'Receptionist', 'Male', 'SSN11', 'Single'),
('Huda Aly', 'Receptionist', 'Female', 'SSN12', 'Married'),
('Samy Galal', 'Billing Manager', 'Male', 'SSN13', 'Single'),
('Amira Aly', 'Housekeeping', 'Female', 'SSN14', 'Married'),
('Mostafa S', 'Housekeeping', 'Male', 'SSN15', 'Single'), 
('Yara Aly', 'Receptionist', 'Female', 'SSN16', 'Single'),
('Ehab Galal', 'Billing Manager', 'Male', 'SSN17', 'Married'),
('Dina Aly', 'Housekeeping', 'Female', 'SSN18', 'Single'),
('Ramy Gad', 'Receptionist', 'Male', 'SSN19', 'Married'), 
('Salma Ihab', 'Admin', 'Female', 'SSN20', 'Single'),
('Wael Aly', 'Receptionist', 'Male', 'SSN21', 'Single'),
('Hanan Aly', 'Receptionist', 'Female', 'SSN22', 'Married'),
('Samy Badr', 'Billing Manager', 'Male', 'SSN23', 'Single'), 
('Ghada Aly', 'Housekeeping', 'Female', 'SSN24', 'Married'),
('Sherif S', 'Housekeeping', 'Male', 'SSN25', 'Single'),
('Tala Aly', 'Receptionist', 'Female', 'SSN26', 'Single'),
('Tamer Gal', 'Billing Manager', 'Male', 'SSN27', 'Married'), 
('Ola Aly', 'Housekeeping', 'Female', 'SSN28', 'Single'),
('Basem Gad', 'Receptionist', 'Male', 'SSN29', 'Married'), 
('Jana Ihab', 'Admin', 'Female', 'SSN30', 'Single');

===============================================================================

--2_ RoomTypes Table
--"This lookup table defines the core revenue drivers of the hotel. 
--It acts as a 'Price Catalog' that categorizes rooms into Single, 
--Double, or Suites, with their respective pricing.
--From an analytical perspective, this table is the foundation for Revenue Management,
--allowing us to calculate Expected ROI,perform Price Sensitivity Analysis, and categorize 
--sales performance based on room tiers."

CREATE TABLE RoomTypes (          
    RoomTypeID VARCHAR(50) PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL, 
    NightlyPrice DECIMAL(10, 2) NOT NULL CHECK (NightlyPrice > 0)
);
INSERT INTO RoomTypes VALUES
('SNG', 'Single', 500),
('DBL', 'Double', 900), 
('SUI', 'Suite', 2500);

================================================================================
--3_ Buildings Table
--"This table serves as the primary master data for the hotel's infrastructure. 
--It defines the physical locations and capacity limits (Floors) of the property.
--For a Data Analyst, this table is the starting point for Geospatial & 
--Resource Distribution Analysis, allowing us to compare performance metrics—like occupancy 
--or maintenance costs—between different towers or locations (e.g., Tower A vs. Tower B)."

CREATE TABLE Buildings (
    BuildingID VARCHAR(50) PRIMARY KEY,
    BuildingName VARCHAR(100) NOT NULL,
    Address_B VARCHAR(200),
    Floors INT
);
INSERT INTO Buildings VALUES 
('B1', 'Tower A', 'Street 1', 10),
('B2', 'Tower B', 'Street 2', 5);

================================================================================
--4_Rooms Table
--"The Rooms table functions as the core asset management repository.
--It maintains the physical inventory of the hotel and tracks the real-time 
--'AvailabilityStatus' of each unit. From an analytical perspective,
--this table is vital for calculating the Occupancy Rate, tracking maintenance downtime,
--and performing Capacity Planning to ensure the hotel is maximizing its revenue per available room (RevPAR)."

CREATE TABLE Rooms (
    RoomID VARCHAR(50) PRIMARY KEY,
    RoomNumber VARCHAR(10) NOT NULL UNIQUE,
    RoomTypeID VARCHAR(50) NOT NULL,
    BuildingID VARCHAR(50) NOT NULL,
    AvailabilityStatus VARCHAR(20) DEFAULT 'Available' 
        CHECK (AvailabilityStatus IN ('Available','Occupied','Maintenance')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (RoomTypeID) REFERENCES RoomTypes(RoomTypeID),
    FOREIGN KEY (BuildingID) REFERENCES Buildings(BuildingID)
);

CREATE NONCLUSTERED INDEX IX_Rooms_RoomTypeID
ON Rooms (RoomTypeID);

CREATE NONCLUSTERED INDEX IX_Rooms_BuildingID
ON Rooms (BuildingID);

CREATE NONCLUSTERED INDEX IX_Rooms_AvailabilityStatus
ON Rooms (AvailabilityStatus);

INSERT INTO Rooms (RoomID, RoomNumber, RoomTypeID, BuildingID, AvailabilityStatus) VALUES
('R1','101','SNG','B1','Occupied'),
('R2','102','SNG','B1','Available'),
('R3','103','DBL','B1','Available'),
('R4','104','DBL','B1','Occupied'),
('R5','105','SUI','B1','Maintenance'),
('R6','106','SNG','B1','Available'),
('R7','107','SNG','B1','Occupied'),
('R8','108','DBL','B1','Available'),
('R9','109','DBL','B1','Occupied'),
('R10','110','SUI','B1','Available'),
('R11','201','SNG','B2','Occupied'),
('R12','202','SNG','B2','Available'),
('R13','203','DBL','B2','Available'),
('R14','204','DBL','B2','Occupied'),
('R15','205','SUI','B2','Maintenance'),
('R16','206','SNG','B2','Available'),
('R17','207','SNG','B2','Occupied'),
('R18','208','DBL','B2','Available'),
('R19','209','DBL','B2','Occupied'),
('R20','210','SUI','B2','Available'),
('R21','301','SNG','B1','Available'),
('R22','302','SNG','B1','Occupied'),
('R23','303','DBL','B1','Available'),
('R24','304','DBL','B1','Occupied'),
('R25','305','SUI','B1','Available'),
('R26','401','SNG','B2','Available'),
('R27','402','SNG','B2','Occupied'),
('R28','403','DBL','B2','Available'),
('R29','404','DBL','B2','Occupied'),
('R30','405','SUI','B2','Available');
select * from Rooms;

================================================================================
--5-Guests Table 
--"The Guests table serves as the primary Customer Relationship Management (CRM) hub.
--It stores unique identifiers, contact details, and demographic data for every visitor. 
--This table is essential for tracking Customer Lifetime Value (CLV), identifying 
--'Repeated Guests,' and analyzing 'Guest Origin' (Country). It enables the marketing department 
--to create personalized offers and loyalty programs based on historical stay patterns."
CREATE TABLE Guests (
    GuestID VARCHAR(50) PRIMARY KEY,
    FullName VARCHAR(150) NOT NULL,
    NationalID_Passport VARCHAR(50) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    Email VARCHAR(100),
    City VARCHAR(50),
    DateAdded DATETIME DEFAULT GETDATE()
);

CREATE NONCLUSTERED INDEX IX_Guests_FullName
ON Guests (FullName);

CREATE NONCLUSTERED INDEX IX_Guests_NationalID
ON Guests (NationalID_Passport);


INSERT INTO Guests (GuestID, FullName, NationalID_Passport, Phone, Email, City) VALUES
('G1','John Doe','ID1','010','j1@m.com','Cairo'),
('G2','Jane Smith','ID2','011','j2@m.com','Alex'),
('G3','Ali Omar','ID3','012','a3@m.com','Giza'),
('G4','Sara Gad','ID4','013','s4@m.com','Suez'),
('G5','Mona Aly','ID5','014','m5@m.com','Cairo'),
('G6','Ziad S','ID6','015','z6@m.com','Alex'),
('G7','Tamer H','ID7','016','t7@m.com','Giza'),
('G8','Noha G','ID8','017','n8@m.com','Suez'),
('G9','Karem A','ID9','018','k9@m.com','Cairo'),
('G10','Maya Z','ID10','019','m10@m.com','Alex'),
('G11','Fady H','ID11','020','f11@m.com','Giza'),
('G12','Huda S','ID12','021','h12@m.com','Suez'),
('G13','Samy A','ID13','022','s13@m.com','Cairo'),
('G14','Amira Z','ID14','023','a14@m.com','Alex'),
('G15','Yara S','ID15','024','y15@m.com','Giza'),
('G16','Mostafa','ID16','025','m16@m.com','Suez'),
('G17','Ehab G','ID17','026','e17@m.com','Cairo'),
('G18','Dina A','ID18','027','d18@m.com','Alex'),
('G19','Ramy S','ID19','028','r19@m.com','Giza'),
('G20','Salma I','ID20','029','s20@m.com','Suez'),
('G21','Wael H','ID21','030','w21@m.com','Cairo'),
('G22','Hanan S','ID22','031','h22@m.com','Alex'),
('G23','Samy B','ID23','032','s23@m.com','Giza'),
('G24','Ghada A','ID24','033','g24@m.com','Suez'),
('G25','Sherif','ID25','034','s25@m.com','Cairo'),
('G26','Tala S','ID26','035','t26@m.com','Alex'),
('G27','Tamer G','ID27','036','t27@m.com','Giza'),
('G28','Ola A','ID28','037','o28@m.com','Suez'),
('G29','Basem G','ID29','038','b29@m.com','Cairo'),
('G30','Jana I','ID30','039','j30@m.com','Alex');
select * from Guests;

================================================================================
--6-Bookings Table 
--"The Bookings table acts as the central transactional engine of the database.
--It captures the complete lifecycle of a reservation—from the initial 'Lead Time' to the final
--'Check-out' status. This table is the cornerstone for calculating Cancellation Rates, forecasting 
--future demand, and evaluating the performance of various 'Distribution Channels' and 'Market Segments'. 
--It bridges the gap between guest demand and room supply."

CREATE TABLE Services (
    ServiceID VARCHAR(50) PRIMARY KEY,
    ServiceName VARCHAR(100) NOT NULL, 
    Price DECIMAL(10, 2) NOT NULL CHECK (Price >= 0),
    MaxUsagePerDay INT,
    IsActive BIT DEFAULT 1
);

INSERT INTO Services VALUES
('S1','Spa',500,10,1), 
('S2','Laundry',100,50,1), 
('S3','Dinner',300,100,1);
 select * from Services;

================================================================================
--7-Reservations Table
--The Reservations table serves as the primary Transactional Ledger of the system, 
--capturing the end-to-end journey of a guest's stay. 
--It is the central junction where Guest profiles, Room inventory, and Employee operations meet.
--From an analytical and business intelligence perspective, this table is the most critical for:
--Revenue Management: By tracking NightlyRateAtBooking, discount, and the calculated nights column, 
--the system can perform precise financial forecasting and analyze pricing trends.
--Operational Tracking: It monitors the lifecycle of a booking through the reservation_status
--(from 'confirmed' to 'checked_out' or 'cancelled'), allowing management to calculate Cancellation Rates 
--and No-Show percentages.
--Customer Behavior Analysis: Columns like booking_source and lead_time (calculated as the difference between 
--booking_date and check_in_date) are vital for Market Segmentation and understanding how customers reach the hotel.
--Performance Auditing: By recording which employees handled the check-in and check-out processes, the hotel can 
--audit operational efficiency and staff accountability."

CREATE TABLE Reservations (
    ReservationID INT IDENTITY(1,1) PRIMARY KEY,
    GuestID VARCHAR(50) NOT NULL,
    RoomID VARCHAR(50) NOT NULL,
    EmployeeID INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    adults_count INT DEFAULT 1 CHECK (adults_count >= 1),
    children_count INT DEFAULT 0 CHECK (children_count >= 0),
    
    nights AS (DATEDIFF(day, check_in_date, check_out_date)),

    discount DECIMAL(10,2) DEFAULT 0,
    NightlyRateAtBooking DECIMAL(10,2) DEFAULT 0,
    booking_date DATETIME DEFAULT GETDATE(),
    CheckedInByEmployeeID INT,
    CheckedOutByEmployeeID INT,
    reservation_status VARCHAR(20) DEFAULT 'confirmed' 
        CHECK (reservation_status IN ('confirmed','checked_in','checked_out','cancelled','no_show')),
    booking_source VARCHAR(20) 
        CHECK (booking_source IN ('website','mobile_app','agent','walk_in','phone')),
    
    CancellationReason VARCHAR(255), 
    special_requests NVARCHAR(MAX),

    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    CONSTRAINT CHK_Dates CHECK (check_out_date > check_in_date)
);

CREATE NONCLUSTERED INDEX IX_Reservations_GuestID
ON Reservations (GuestID);

CREATE NONCLUSTERED INDEX IX_Reservations_RoomID
ON Reservations (RoomID);

CREATE NONCLUSTERED INDEX IX_Reservations_CheckInOut
ON Reservations (check_in_date, check_out_date);

CREATE NONCLUSTERED INDEX IX_Reservations_ReservationStatus
ON Reservations (reservation_status);

INSERT INTO Reservations (GuestID, RoomID, EmployeeID, check_in_date, check_out_date, NightlyRateAtBooking, reservation_status, booking_date) VALUES
('G1','R1',1,'2025-11-01','2025-11-05',500,'checked_out','2025-10-25'),
('G2','R2',2,'2026-01-10','2026-01-15',500,'cancelled','2026-01-01'),
('G3','R4',1,'2026-02-25','2026-03-05',900,'checked_in','2026-02-20'),
('G4','R7',2,'2025-12-15','2025-12-20',500,'checked_out','2025-12-01'),
('G5','R9',1,'2026-01-20','2026-01-25',900,'checked_out','2026-01-15'),
('G6','R11',1,'2026-02-28','2026-03-04',500,'checked_in','2026-02-25'),
('G7','R14',2,'2026-01-05','2026-01-10',900,'checked_out','2026-01-01'),
('G8','R17',1,'2025-11-20','2025-11-25',500,'checked_out','2025-11-15'),
('G9','R19',2,'2026-02-28','2026-03-05',900,'checked_in','2026-02-25'),
('G10','R22',1,'2026-01-15','2026-01-20',500,'checked_out','2026-01-10'),
('G11','R24',2,'2025-12-01','2025-12-05',900,'checked_out','2025-11-25'),
('G12','R27',1,'2026-03-01','2026-03-05',500,'checked_in','2026-02-28'),
('G13','R29',2,'2026-01-10','2026-01-15',900,'checked_out','2026-01-05'),
('G14','R1',1,'2026-02-01','2026-02-05',500,'checked_out','2026-01-25'),
('G15','R4',2,'2026-01-20','2026-01-25',900,'checked_out','2026-01-15'),
('G16','R7',1,'2025-12-10','2025-12-15',500,'checked_out','2025-12-05'),
('G19','R17',2,'2026-02-01','2026-02-05',500,'checked_out','2026-01-25'),
('G20','R19',1,'2025-11-05','2025-11-10',900,'checked_out','2025-11-01'),
('G21','R22',2,'2026-03-01','2026-03-05',500,'checked_in','2026-02-28'),
('G22','R24',1,'2026-01-20','2026-01-25',900,'checked_out','2026-01-15'),
('G23','R27',2,'2026-02-10','2026-02-15',500,'checked_out','2026-02-01'),
('G24','R29',1,'2025-12-25','2025-12-30',900,'checked_out','2025-12-20'),
('G25','R2',2,'2026-03-01','2026-03-05',500,'confirmed','2026-02-28'),
('G26','R3',1,'2026-02-15','2026-02-20',900,'checked_out','2026-02-10'),
('G27','R6',2,'2026-01-01','2026-01-05',500,'checked_out','2025-12-25'),
('G28','R8',1,'2026-03-01','2026-03-05',900,'checked_in','2026-02-28'),
('G29','R12',2,'2026-02-10','2026-02-15',500,'checked_out','2026-02-05'),
('G30','R13',1,'2025-11-15','2025-11-20',900,'checked_out','2025-11-10');



select * from Reservations;
================================================================================
--8-Invoices Table
--"The Payments table functions as the financial audit trail for the hotel.
--It records every monetary transaction, including 'Deposit Types,' total 'ADR' (Average Daily Rate),
--and additional service charges. Analytically, this table is the foundation for Revenue Management, 
--allowing the hotel to monitor cash flow, analyze pricing elasticity, and ensure that 'RevPAR' 
--(Revenue Per Available Room) targets are being met."
CREATE TABLE Invoices (
    InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
    ReservationID INT NOT NULL UNIQUE,
    InvoiceDate DATE NOT NULL DEFAULT GETDATE(),
    TotalRoomCharge DECIMAL(10,2) NOT NULL,
    TotalServicesCharge DECIMAL(10,2) DEFAULT 0,
    DiscountAmount DECIMAL(10,2) DEFAULT 0,
    
    NetTotalAmount AS (TotalRoomCharge + TotalServicesCharge - DiscountAmount),
    
    PaidAmount DECIMAL(10,2) DEFAULT 0,
    InvoiceStatus VARCHAR(20) DEFAULT 'unpaid' 
        CHECK (InvoiceStatus IN ('unpaid','partial','paid','refunded')),
    
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID)
);

CREATE NONCLUSTERED INDEX IX_Invoices_ReservationID
ON Invoices (ReservationID);

CREATE NONCLUSTERED INDEX IX_Invoices_InvoiceStatus
ON Invoices (InvoiceStatus);

INSERT INTO Invoices (ReservationID, InvoiceDate, TotalRoomCharge, TotalServicesCharge, DiscountAmount, PaidAmount, InvoiceStatus) VALUES
(47, '2025-11-05', 2000.00, 500.00, 0, 2500.00, 'paid'),
(48, '2026-01-15', 2500.00, 200.00, 100.00, 0, 'unpaid'), 
(49, '2026-03-01', 7200.00, 600.00, 0, 0, 'unpaid'),    
(50, '2025-12-20', 2500.00, 200.00, 0, 2700.00, 'paid'),
(51, '2026-01-25', 4500.00, 450.00, 200.00, 4750.00, 'paid'),
(52, '2026-03-01', 2000.00, 500.00, 0, 1000.00, 'partial'), 
(53, '2026-01-10', 4500.00, 100.00, 0, 4600.00, 'paid'),
(54, '2025-11-25', 2500.00, 600.00, 0, 3100.00, 'paid'),
(55, '2026-03-01', 4500.00, 200.00, 0, 0, 'unpaid'),
(56, '2026-01-20', 2500.00, 300.00, 0, 2800.00, 'paid'),
(57, '2025-12-05', 3600.00, 500.00, 0, 1500.00, 'partial'), 
(58, '2026-03-01', 2000.00, 500.00, 0, 2500.00, 'paid'),
(59, '2026-01-15', 4500.00, 300.00, 0, 4800.00, 'paid'),
(60, '2026-02-05', 2000.00, 400.00, 0, 2400.00, 'paid'),
(61, '2026-01-25', 4500.00, 300.00, 100.00, 4700.00, 'paid'),
(62, '2025-12-15', 2500.00, 500.00, 0, 0, 'unpaid'),      
(63, '2026-03-01', 2000.00, 300.00, 0, 2300.00, 'paid'),
(64, '2026-01-10', 4500.00, 300.00, 0, 4800.00, 'paid'),
(65, '2026-02-05', 2000.00, 200.00, 0, 2200.00, 'paid'),
(66, '2025-11-10', 4500.00, 600.00, 0, 5100.00, 'paid'),
(67, '2026-03-01', 2000.00, 500.00, 0, 0, 'unpaid'),
(68, '2026-01-25', 4500.00, 200.00, 0, 4700.00, 'paid'),
(69, '2026-02-15', 2500.00, 300.00, 0, 2800.00, 'paid'),
(70, '2025-12-30', 4500.00, 200.00, 0, 4700.00, 'paid'),
(71, '2026-03-01', 2000.00, 300.00, 0, 2300.00, 'paid'),
(72, '2026-02-20', 4500.00, 500.00, 0, 5000.00, 'paid'),
(73, '2026-01-05', 2000.00, 100.00, 0, 2100.00, 'paid'),
(74, '2026-03-01', 3600.00, 600.00, 0, 4200.00, 'paid');
select * from Invoices;
==============================================================================
--9-Payments Table
--The Payments table functions as the hotel's Financial Audit Trail. 
--It captures every actual monetary inflow linked to a specific invoice. While the 'Invoices' 
--table shows what should be paid, this table confirms what has been paid, when, and how.
--From an analytical perspective, this table is vital for:
--Cash Flow Monitoring: By tracking AmountPaid and PaymentDate, management can monitor daily liquidity and financial health.
--Payment Method Analysis: Analyzing the PaymentMethod column (Cash, Card, Online, Wallet) helps the hotel understand guest
--preferences and optimize partnership agreements with banks or payment gateways.
--Revenue Integrity: The use of PaymentStatus ensures that 'Failed' or 'Pending' transactions are flagged, preventing revenue 
--leakage.
--Staff Accountability: Linking each payment to an EmployeeID allows the hotel to track which staff members are handling 
--the most transactions and ensures accountability at the front desk or point of sale."
CREATE TABLE Payments (
    PaymentID VARCHAR(50) PRIMARY KEY,
    InvoiceID INT NOT NULL,
    EmployeeID INT NOT NULL, 
    AmountPaid DECIMAL(10, 2) NOT NULL CHECK (AmountPaid > 0),
    PaymentMethod VARCHAR(20) NOT NULL CHECK (PaymentMethod IN ('Cash','Card','Online','Wallet')),
    PaymentDate DATETIME DEFAULT GETDATE(),
    PaymentStatus VARCHAR(20) DEFAULT 'Completed' CHECK (PaymentStatus IN ('Completed','Pending','Failed')),
    
    FOREIGN KEY (InvoiceID) REFERENCES Invoices(InvoiceID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE NONCLUSTERED INDEX IX_Payments_InvoiceID
ON Payments (InvoiceID);

CREATE NONCLUSTERED INDEX IX_Payments_EmployeeID
ON Payments (EmployeeID);

CREATE NONCLUSTERED INDEX IX_Payments_PaymentDate
ON Payments (PaymentDate);
INSERT INTO Payments (PaymentID, InvoiceID, EmployeeID, AmountPaid, PaymentMethod, PaymentDate) VALUES
('P-101', 2, 3, 2500.00, 'Card', '2025-11-05'),
('P-102', 5, 7, 2700.00, 'Cash', '2025-12-20'),
('P-103', 6, 13, 4750.00, 'Online', '2026-01-25'),
('P-104', 7, 17, 1000.00, 'Wallet', '2026-03-01'), 
('P-105', 8, 23, 4600.00, 'Card', '2026-01-10'),
('P-106', 9, 27, 3100.00, 'Cash', '2025-11-25'),
('P-107', 11, 3, 2800.00, 'Online', '2026-01-20'),
('P-108', 12, 7, 1500.00, 'Card', '2025-12-05'), 
('P-109', 13, 13, 2500.00, 'Cash', '2026-03-01'),
('P-110', 14, 17, 4800.00, 'Online', '2026-01-15'),
('P-111', 15, 23, 2400.00, 'Card', '2026-02-05'),
('P-112', 16, 27, 4700.00, 'Wallet', '2026-01-25'),
('P-113', 18, 3, 2300.00, 'Cash', '2026-03-01'),
('P-114', 19, 7, 4800.00, 'Card', '2026-01-10'),
('P-115', 20, 13, 2200.00, 'Online', '2026-02-05'),
('P-116', 21, 17, 5100.00, 'Cash', '2025-11-10'),
('P-117', 23, 23, 4700.00, 'Card', '2026-01-25'),
('P-118', 24, 27, 2800.00, 'Online', '2026-02-15'),
('P-119', 25, 3, 4700.00, 'Cash', '2025-12-30'),
('P-120', 26, 7, 2300.00, 'Card', '2026-03-01'),
('P-121', 27, 13, 5000.00, 'Online', '2026-02-20'),
('P-122', 28, 17, 2100.00, 'Wallet', '2026-01-05'),
('P-123', 29, 23, 4200.00, 'Cash', '2026-03-01'),
('P-126', 2, 7, 100.00, 'Cash', '2025-11-06'), 
('P-127', 5, 13, 50.00, 'Card', '2025-12-21'),
('P-128', 8, 17, 100.00, 'Online', '2026-01-11'),
('P-129', 11, 23, 200.00, 'Cash', '2026-01-21'),
('P-130', 14, 27, 300.00, 'Card', '2026-01-16');
==============================================================================
--10-HousekeepingLogs Table

CREATE TABLE HousekeepingLogs (
    LogID VARCHAR(50) PRIMARY KEY,
    RoomID VARCHAR(50) NOT NULL,
    EmployeeID INT NOT NULL, 
    CleaningDate DATE NOT NULL,
    StartTime TIME,
    EndTime TIME,
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    CONSTRAINT CHK_Time CHECK (EndTime > StartTime)
);
CREATE NONCLUSTERED INDEX IX_HousekeepingLogs_RoomID
ON HousekeepingLogs (RoomID);

CREATE NONCLUSTERED INDEX IX_HousekeepingLogs_CleaningDate
ON HousekeepingLogs (CleaningDate);
 
INSERT INTO HousekeepingLogs (LogID, RoomID, EmployeeID, CleaningDate, StartTime, EndTime) VALUES
('LOG-01', 'R1', 4, '2026-03-01', '08:00:00', '08:45:00'),
('LOG-02', 'R2', 5, '2026-03-01', '08:30:00', '09:15:00'),
('LOG-03', 'R3', 8, '2026-03-01', '09:00:00', '10:00:00'),
('LOG-04', 'R4', 12, '2026-03-01', '09:30:00', '10:10:00'),
('LOG-05', 'R5', 15, '2026-03-01', '10:00:00', '11:00:00'),
('LOG-06', 'R6', 16, '2026-03-01', '10:15:00', '11:00:00'),
('LOG-07', 'R7', 20, '2026-03-01', '11:00:00', '11:45:00'),
('LOG-08', 'R8', 24, '2026-03-01', '11:30:00', '12:15:00'),
('LOG-09', 'R9', 28, '2026-03-01', '12:00:00', '13:00:00'),
('LOG-10', 'R10', 4, '2026-03-01', '12:30:00', '13:20:00'),
('LOG-11', 'R11', 5, '2026-03-01', '13:00:00', '14:00:00'),
('LOG-12', 'R12', 8, '2026-03-01', '14:30:00', '15:30:00'),
('LOG-13', 'R13', 12, '2026-03-01', '15:00:00', '16:00:00'),
('LOG-14', 'R14', 15, '2026-03-01', '08:00:00', '09:00:00'),
('LOG-15', 'R15', 16, '2026-03-01', '08:30:00', '09:15:00'),
('LOG-16', 'R16', 20, '2026-03-01', '09:00:00', '09:45:00'),
('LOG-17', 'R17', 24, '2026-03-01', '10:00:00', '11:00:00'),
('LOG-18', 'R18', 28, '2026-03-01', '11:00:00', '12:15:00'),
('LOG-19', 'R19', 4, '2026-03-01', '12:00:00', '12:45:00'),
('LOG-20', 'R20', 5, '2026-03-01', '13:00:00', '13:50:00'),
('LOG-21', 'R21', 8, '2026-02-28', '08:00:00', '09:00:00'),
('LOG-22', 'R22', 12, '2026-02-28', '09:00:00', '09:40:00'),
('LOG-23', 'R23', 15, '2026-02-28', '10:00:00', '11:15:00'),
('LOG-24', 'R24', 16, '2026-02-28', '11:00:00', '11:50:00'),
('LOG-25', 'R25', 20, '2026-02-28', '12:00:00', '13:00:00'),
('LOG-26', 'R26', 24, '2026-02-28', '14:30:00', '15:45:00'),
('LOG-27', 'R27', 28, '2026-02-28', '15:15:00', '16:00:00'),
('LOG-28', 'R28', 4, '2026-02-28', '08:30:00', '09:15:00'),
('LOG-29', 'R29', 5, '2026-02-28', '09:45:00', '10:30:00'),
('LOG-30', 'R30', 8, '2026-02-28', '11:00:00', '11:55:00');
==============================================================================
CREATE TABLE ServiceUsages (
    UsageID VARCHAR(50) PRIMARY KEY,
    ReservationID INT NOT NULL,
    ServiceID VARCHAR(50) NOT NULL,
    UsageDate DATE NOT NULL,
    Quantity INT DEFAULT 1 CHECK (Quantity > 0),
    TotalCharge DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID)
);
CREATE NONCLUSTERED INDEX IX_ServiceUsages_ReservationID
ON ServiceUsages (ReservationID);

CREATE NONCLUSTERED INDEX IX_ServiceUsages_ServiceID
ON ServiceUsages (ServiceID);


INSERT INTO ServiceUsages (UsageID, ReservationID, ServiceID, UsageDate, Quantity, TotalCharge) VALUES
('USG-101', 47, 'S1', '2025-11-02', 1, 500.00), 
('USG-102', 48, 'S2', '2026-01-11', 2, 200.00), 
('USG-103', 49, 'S3', '2026-02-26', 2, 600.00), 
('USG-104', 50, 'S1', '2025-12-16', 1, 500.00), 
('USG-105', 51, 'S2', '2026-01-21', 3, 300.00), 
('USG-106', 52, 'S1', '2026-02-28', 1, 500.00),
('USG-107', 53, 'S2', '2026-01-06', 1, 100.00),
('USG-108', 54, 'S3', '2025-11-21', 2, 600.00),
('USG-109', 55, 'S1', '2026-03-01', 1, 500.00), 
('USG-110', 56, 'S2', '2026-01-16', 2, 200.00), 
('USG-111', 57, 'S1', '2025-12-02', 1, 500.00),
('USG-112', 58, 'S2', '2026-03-02', 5, 500.00),
('USG-113', 59, 'S3', '2026-01-11', 1, 300.00),
('USG-114', 60, 'S1', '2026-02-02', 2, 1000.00), 
('USG-115', 61, 'S2', '2026-01-21', 2, 200.00), 
('USG-116', 62, 'S1', '2025-12-11', 1, 500.00),
('USG-117', 63, 'S2', '2026-03-02', 3, 300.00),
('USG-118', 64, 'S3', '2026-01-06', 1, 300.00),
('USG-119', 65, 'S1', '2026-02-02', 1, 500.00), 
('USG-120', 66, 'S2', '2025-11-06', 4, 400.00), 
('USG-121', 67, 'S1', '2026-03-01', 1, 500.00),
('USG-122', 68, 'S2', '2026-01-21', 2, 200.00),
('USG-123', 69, 'S3', '2026-02-11', 1, 300.00),
('USG-124', 70, 'S1', '2025-12-26', 1, 500.00), 
('USG-125', 71, 'S2', '2026-03-02', 2, 200.00), 
('USG-126', 72, 'S1', '2026-02-16', 1, 500.00),
('USG-127', 73, 'S2', '2026-01-02', 1, 100.00),
('USG-128', 74, 'S3', '2026-03-02', 2, 600.00);
==============================================================================
CREATE TABLE GuestReviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    ReservationID INT NOT NULL UNIQUE,
    GuestID VARCHAR(50) NOT NULL,
    OverallRating INT CHECK (OverallRating BETWEEN 1 AND 5), 
    CleanlinessRating INT CHECK (CleanlinessRating BETWEEN 1 AND 5),
    StaffServiceRating INT CHECK (StaffServiceRating BETWEEN 1 AND 5),
    ReviewComment NVARCHAR(MAX),
    ReviewDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID),
    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID)
);

CREATE NONCLUSTERED INDEX IX_Reviews_Rating ON GuestReviews (OverallRating);


INSERT INTO GuestReviews (ReservationID, GuestID, OverallRating, CleanlinessRating, StaffServiceRating, ReviewComment) VALUES
(47, 'G1', 5, 5, 5, 'Perfect stay and very clean!'),
(48, 'G10', 2, 3, 2, 'Room was not ready on time.'),
(49, 'G11', 4, 4, 5, 'Great staff service, room was good.'),
(50, 'G12', 5, 5, 5, 'Everything was top notch.'),
(51, 'G13', 3, 2, 4, 'Service is good but cleaning needs improvement.'),
(52, 'G14', 4, 4, 4, 'Good experience overall.'),
(53, 'G15', 5, 5, 5, 'Highly recommended hotel.'),
(54, 'G16', 1, 1, 2, 'Disappointed with the room condition.'),
(55, 'G17', 4, 3, 5, 'Friendly reception team.'),
(56, 'G18', 5, 5, 5, 'The best experience ever!'),
(57, 'G19', 3, 3, 3, 'Average hotel, nothing special.'),
(58, 'G2', 4, 5, 4, 'Very clean rooms.'),
(59, 'G20', 5, 5, 5, 'Amazing luxury suite.'),
(60, 'G21', 2, 2, 3, 'Old furniture, needs renovation.'),
(61, 'G22', 4, 4, 4, 'Quiet and comfortable.'),
(62, 'G23', 5, 5, 5, 'Excellent value for money.'),
(63, 'G24', 3, 3, 4, 'Check-in took too long.'),
(64, 'G25', 4, 5, 4, 'I loved the sea view room.'),
(65, 'G26', 5, 4, 5, 'Professional housekeeping team.'),
(66, 'G27', 1, 2, 1, 'Bad experience, will not return.'),
(67, 'G28', 4, 4, 4, 'Clean and cozy.'),
(68, 'G29', 5, 5, 5, 'Superb hospitality.'),
(69, 'G3', 3, 3, 3, 'It was okay for a short stay.'),
(70, 'G30', 4, 4, 5, 'Good location and clean rooms.'),
(71, 'G4', 5, 5, 5, 'Absolutely fantastic service!'),
(72, 'G5', 2, 2, 2, 'Not what I expected.'),
(73, 'G6', 4, 4, 4, 'Standard stay, no complaints.'),
(74, 'G7', 5, 5, 5, 'The staff went above and beyond.');

=============================================================================
CREATE TABLE Promotions (
    PromoID VARCHAR(50) PRIMARY KEY,
    PromoName VARCHAR(100) NOT NULL,
    DiscountPercentage DECIMAL(5,2) CHECK (DiscountPercentage BETWEEN 0 AND 100),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    IsActive BIT DEFAULT 1,
    CONSTRAINT CHK_PromoDates CHECK (EndDate >= StartDate)
);
INSERT INTO Promotions (PromoID, PromoName, DiscountPercentage, StartDate, EndDate, IsActive) VALUES
('SUMMER26', 'Summer Vacation Offer', 20.00, '2026-06-01', '2026-08-31', 1),
('WINTER25', 'Winter Warmth Deal', 15.00, '2025-11-01', '2026-02-28', 1),
('NEWYEAR', 'New Year Celebration', 25.00, '2025-12-25', '2026-01-05', 0),
('EID2026', 'Eid Al-Fitr Discount', 10.00, '2026-03-20', '2026-04-05', 1),
('WELCOME', 'First Time Guest', 5.00, '2025-01-01', '2026-12-31', 1);
=============================================================================
CREATE TABLE LoyaltyProgram (
    LoyaltyID INT IDENTITY(1,1) PRIMARY KEY,
    GuestID VARCHAR(50) NOT NULL UNIQUE,
    TotalPoints INT DEFAULT 0,
    MembershipLevel VARCHAR(20) DEFAULT 'Bronze' 
        CHECK (MembershipLevel IN ('Bronze', 'Silver', 'Gold', 'Platinum')),
    LastUpdated DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID)
);
INSERT INTO LoyaltyProgram (GuestID, TotalPoints, MembershipLevel) VALUES
('G1', 1500, 'Gold'), 
('G2', 200, 'Bronze'),
('G3', 800, 'Silver'),
('G4', 100, 'Bronze'),
('G5', 1200, 'Gold'), 
('G6', 450, 'Silver'),
('G7', 950, 'Silver'), 
('G8', 50, 'Bronze'), 
('G9', 600, 'Silver'),
('G10', 2000, 'Platinum'), 
('G11', 300, 'Bronze'), 
('G12', 150, 'Bronze'),
('G13', 1100, 'Gold'), 
('G14', 400, 'Silver'), 
('G15', 700, 'Silver'),
('G16', 50, 'Bronze'), 
('G17', 1300, 'Gold'), 
('G18', 250, 'Bronze'),
('G19', 900, 'Silver'), 
('G20', 1600, 'Gold'), 
('G21', 100, 'Bronze'),
('G22', 500, 'Silver'), 
('G23', 350, 'Bronze'), 
('G24', 50, 'Bronze'),
('G25', 1800, 'Platinum'), 
('G26', 750, 'Silver'), 
('G27', 200, 'Bronze'),
('G28', 1000, 'Gold'), 
('G29', 400, 'Silver'), 
('G30', 2200, 'Platinum');