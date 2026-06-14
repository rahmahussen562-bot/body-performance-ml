تفعيل إشعارات Gmail على سطح المكتب.
   حسنًا  لا شكرًا
المحادثات
تم استخدام %6 من 15 غيغابايت
بنود · الخصوصية · سياسات البرنامج
آخر نشاط للحساب: قبل ساعة واحدة
التفاصيل
--Q4) Create a view vw_ReservationDetails that returns:
--  ReservationID, GuestName, RoomNumber, RoomType
--  CheckInDate, CheckOutDate, Nights
--  ReservationStatus (Booked/Checked-in/Checked-out/Cancelled)
--  TotalRoomCharge (Nights × NightlyRate)

-- Create a view to display detailed reservation information
CREATE VIEW vw_ReservationDetails AS

SELECT 
    r.ReservationID, 
    -- Select the unique reservation identifier from Reservations table

    g.FullName AS GuestName, 
    -- Get the guest's full name from Guests table and rename it as GuestName

    rm.RoomNumber, 
    -- Retrieve the room number from the Rooms table

    rt.TypeName AS RoomType, 
    -- Retrieve the room type name (e.g., Standard, Deluxe) from RoomTypes

    r.check_in_date AS CheckInDate, 
    -- Select the check-in date and rename it for readability

    r.check_out_date AS CheckOutDate, 
    -- Select the check-out date and rename it

    r.nights AS Nights, 
    -- Number of nights the guest will stay

    r.reservation_status AS ReservationStatus, 
    -- Current reservation status (Booked, Checked-in, Checked-out, Cancelled)

    (r.nights * rt.NightlyPrice) AS TotalRoomCharge 
    -- Calculate the total room charge by multiplying nights by the nightly price

FROM Reservations r 
-- Use Reservations as the main table because it contains the reservation information

JOIN Guests g 
    ON r.GuestID = g.GuestID 
-- Join Guests to get the guest name using the GuestID foreign key

JOIN Rooms rm 
    ON r.RoomID = rm.RoomID 
-- Join Rooms to obtain the room number associated with the reservation

JOIN RoomTypes rt 
    ON rm.RoomTypeID = rt.RoomTypeID;
-- Join RoomTypes to retrieve the room type and nightly price



--Q5) Write a query showing cancellation performance by month:
--  YearMonth
--  TotalReservations
--  CancelledReservations
--  CancellationRate%
--Also list the Top 5 cancellation reasons (if stored).

SELECT 
    FORMAT(booking_date,'yyyy-MM') AS YearMonth,
    -- Format the booking date into Year-Month to group reservations monthly

    COUNT(*) AS TotalReservations,
    -- Count all reservations in that month

    SUM(CASE 
        WHEN reservation_status = 'Cancelled' 
        THEN 1 ELSE 0 END) AS CancelledReservations,
    -- Count only reservations where the status is Cancelled

    (SUM(CASE 
        WHEN reservation_status = 'Cancelled' 
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS CancellationRate
    -- Calculate cancellation percentage by dividing cancelled reservations by total reservations

FROM Reservations
-- Use Reservations table because it stores booking date and reservation status

GROUP BY FORMAT(booking_date,'yyyy-MM')
-- Group results by month to analyze cancellations monthly

ORDER BY YearMonth;
-- Sort the results chronologically by month



--Top 5 cancellation reasons
SELECT TOP 5
    CancellationReason,
    -- Select the reason why reservations were cancelled

    COUNT(*) AS TotalCancellations
    -- Count how many times each cancellation reason occurred

FROM Reservations
-- Use Reservations table because cancellation reasons are stored there

WHERE reservation_status = 'Cancelled'
-- Filter only cancelled reservations

GROUP BY CancellationReason
-- Group rows by cancellation reason to count occurrences

ORDER BY TotalCancellations DESC;
-- Sort results from most common cancellation reason to least common



--Q6)Create a view vw_ServiceRevenue that returns:
--  ServiceName, YearMonth
--  TotalUsageCount
--  TotalServiceRevenue
--Then query Top 5 services by revenue for the last 3 months.


-- Create a view to analyze revenue generated from hotel services
CREATE VIEW vw_ServiceRevenue AS

SELECT 
    s.ServiceName,
    -- Retrieve the name of the service (Spa, Laundry, Room Service)

    FORMAT(su.UsageDate,'yyyy-MM') AS YearMonth,
    -- Convert usage date to Year-Month format to analyze monthly revenue

    COUNT(su.UsageID) AS TotalUsageCount,
    -- Count how many times the service was used

    SUM(su.TotalCharge) AS TotalServiceRevenue
    -- Sum all service charges to calculate total revenue from that service

FROM ServiceUsages su
-- Use ServiceUsages because it stores each service usage transaction

JOIN Services s
    ON su.ServiceID = s.ServiceID
-- Join Services table to get the service name associated with the usage

GROUP BY 
    s.ServiceName,
    FORMAT(su.UsageDate,'yyyy-MM');
-- Group data by service and month to calculate monthly service revenue


--Top 5 services revenue (last 3 months)

SELECT TOP 5
    ServiceName,
    -- Display the service name

    SUM(TotalServiceRevenue) AS Revenue
    -- Calculate total revenue for each service

FROM vw_ServiceRevenue
-- Use the previously created view to simplify revenue analysis

WHERE YearMonth >= FORMAT(DATEADD(MONTH,-3,GETDATE()),'yyyy-MM')
-- Filter data to include only the last 3 months

GROUP BY ServiceName
-- Group by service to calculate revenue per service

ORDER BY Revenue DESC;
-- Sort results so the highest revenue services appear first


--Q7)Create a view vw_InvoiceAging that shows:
--  InvoiceID, GuestName, InvoiceDate, TotalAmount, PaidAmount,
--OutstandingAmount
--  AgingBucket: 0–7, 8–30, 31–60, 60+ days
--Then query all outstanding invoices in the 60+ bucket.


-- Create a view to monitor invoice aging and outstanding balances
CREATE VIEW vw_InvoiceAging AS

SELECT 
    i.InvoiceID,
    -- Select the unique invoice identifier

    g.FullName AS GuestName,
    -- Retrieve the guest name associated with the reservation

    i.InvoiceDate,
    -- Select the invoice issue date

    i.NetTotalAmount AS TotalAmount,
    -- Total invoice amount after discounts

    i.PaidAmount,
    -- Amount already paid by the guest

    (i.NetTotalAmount - i.PaidAmount) AS OutstandingAmount,
    -- Calculate remaining unpaid balance

    CASE
        WHEN DATEDIFF(DAY, i.InvoiceDate, GETDATE()) <= 7 
            THEN '0-7 days'
        -- If invoice age is 7 days or less

        WHEN DATEDIFF(DAY, i.InvoiceDate, GETDATE()) <= 30 
            THEN '8-30 days'
        -- If invoice age is between 8 and 30 days

        WHEN DATEDIFF(DAY, i.InvoiceDate, GETDATE()) <= 60 
            THEN '31-60 days'
        -- If invoice age is between 31 and 60 days

        ELSE '60+ days'
        -- If invoice age exceeds 60 days
    END AS AgingBucket

FROM Invoices i
-- Use Invoices table because it contains invoice details

JOIN Reservations r 
    ON i.ReservationID = r.ReservationID
-- Join Reservations to connect invoices with guests

JOIN Guests g 
    ON r.GuestID = g.GuestID;
-- Join Guests to retrieve guest names



--Query invoices in 60+ bucket

SELECT *
-- Select all columns from the aging view

FROM vw_InvoiceAging
-- Use the previously created view

WHERE AgingBucket = '60+ days'
-- Filter invoices that are older than 60 days

AND OutstandingAmount > 0;
-- Ensure only invoices that still have unpaid balance are shown
SELECT 
    FORMAT(PaymentDate, 'yyyy-MM') AS YearMonth, -- Extract Year and Month
    SUM(AmountPaid) AS TotalPaid, -- Total Amounts Paid
    SUM(CASE WHEN PaymentMethod = 'Cash' THEN AmountPaid ELSE 0 END) AS PaidByCash,  -- Cash Paid
    SUM(CASE WHEN PaymentMethod = 'Card' THEN AmountPaid ELSE 0 END) AS PaidByCard, -- Card Paid
    SUM(CASE WHEN PaymentMethod = 'Online' THEN AmountPaid ELSE 0 END) AS PaidOnline, -- Online Paid
    SUM(CASE WHEN PaymentMethod = 'Wallet' THEN AmountPaid ELSE 0 END) AS PaidByWallet, -- Wallet Paid 
    COUNT(CASE WHEN PaymentStats = 'Failed' THEN 1 END) AS FailedCount, -- Number of failed transactions
    COUNT(CASE WHEN PaymentStats = 'Pending' THEN 1 END) AS PendingCount  -- Number of Pending transactions
    
	FROM Payments
GROUP BY 
    FORMAT(PaymentDate, 'yyyy-MM')  -- Grouping operations chronologically by month
ORDER BY 
    YearMonth DESC;  

	

	CREATE VIEW vw_StaffPerformance AS
SELECT 
    Employee.EmpName AS StaffName, -- Assuming this column exists in the Employees table
    JopRole.Role,
    -- Number of reservations created by the employee
    COUNT(DISTINCT CASE WHEN Reservations.EmployeeID = Employee.EmployeeID THEN Reservations.ReservationID END) AS ReservationsHandled,
    
    -- Number of check-ins processed by the employee
    COUNT(DISTINCT CASE WHEN Reservations.CheckedInByEmployeeID = Employee.EmployeeID THEN Reservations.ReservationID END) AS CheckInsProcessed,
    
    -- Number of check-outs processed by the employee
    COUNT(DISTINCT CASE WHEN Reservations.CheckedOutByEmployeeID = Employee.EmployeeID THEN Reservations.ReservationID END) AS CheckOutsProcessed,
    
    -- Total number of check-outs Completed (based on source)
    COUNT(p.payments) AS TotalPaymentsProcessed,
    
    -- Total amounts collected (based on the amount paid column from source)
    SUM(ISNULL(p.AmountPaid, 0)) AS TotalRevenueProcessed

FROM 
    Employee 
LEFT JOIN 
    Reservations  ON Employee.EmployeeID IN (EmployeeID, CheckedInByEmployeeID, CheckedOutByEmployeeID)  --This method isn't the best practice. But if the project is academic
LEFT JOIN 
    payments  ON ReservationID = ReservationID  -- Linking Booking and Payment 
WHERE 
    r.booking_date >= DATEADD(day, -30, GETDATE()) -- Filter data to include only the last 30 days
    OR p.payment_date >= DATEADD(day, -30, GETDATE()) -- Filtering the Last 30 Days
GROUP BY 
    e.EmployeeName, e.Role;

	SELECT TOP 10 
    StaffName, -- Extracting a list of the ten most productive employees
    Role, 
    TotalRevenueProcessed,
    ReservationsHandled,
    CheckInsProcessed,
    CheckOutsProcessed
FROM 
    vw_StaffPerformance
ORDER BY 
    TotalRevenueProcessed DESC;  -- Ranking of employees based on total revenue






	CREATE VIEW vw_HousekeepingPerformance AS
SELECT 
    RoomID,
    -- 1. Number of times each room was cleaned in the last 30 days
    COUNT(LogID) AS CleaningCount,
    -- 2. Average cleaning time in minutes
    AVG(DATEDIFF(MINUTE, StartTime, EndTime)) AS AvgCleaningTimeMinutes, 
    -- 3. Number of times the cleaning was done late (after 2 PM, for example, Cutoff Time)
    SUM(CASE 
	   WHEN EndTime > '14:00:00' THEN 1 ELSE 0 END) AS LateCleaningsCount,
    -- Add cleaning staff (optional for linking)
    COUNT(DISTINCT EmployeeID) AS UniqueStaffAssigned
FROM 
    HousekeepingLogs
WHERE 
    CleaningDate >= DATEADD(day, -30, GETDATE())-- Restrict cleaning records to the last 30 days only to ensure data is up-to-date
GROUP BY 
    RoomID;  -- Data grouping by room to convert individual records into performance indicators