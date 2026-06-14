# 🏨 Hotel Property Management System

<div align="center">

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![SQL Server](https://img.shields.io/badge/SQL%20Server-2019+-CC2927?logo=microsoftsqlserver&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.8+-3776AB?logo=python&logoColor=white)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-F37628?logo=jupyter&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi&logoColor=black)
![Status](https://img.shields.io/badge/status-active-success.svg)

**Modern Hotel Reservation and Billing Management System**

A comprehensive data-driven solution for hotel operations — covering database design, exploratory data analysis, and business intelligence reporting.

</div>

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Installation](#installation)
- [Usage Guide](#usage-guide)
- [Data Analysis](#data-analysis)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)
- [License](#license)
- [Author](#author)

---

## 🎯 Overview

This project is a **graduation project** that demonstrates a full-stack approach to hotel property management. It encompasses:

1. **Database Design & Implementation** — A normalized relational database (SQL Server) managing guests, rooms, reservations, services, invoicing, and payments
2. **Data Insertion & Queries** — Comprehensive SQL scripts for data population and complex analytical queries
3. **Exploratory Data Analysis (EDA)** — Python-based analysis of 119,390 hotel booking records to uncover patterns in cancellations, demand, and guest behavior
4. **Business Intelligence** — Power BI dashboards and Orange data mining workflows for visual reporting and predictive modeling

---

## ✨ Features

### 🗄️ Database Management
- **Normalized Schema** — 10+ interrelated tables with proper constraints and foreign keys
- **Room Management** — Room types, availability tracking, and pricing
- **Reservation System** — Booking lifecycle from check-in to checkout with status tracking
- **Service Billing** — Track ancillary services (restaurant, pool, etc.) per reservation
- **Invoice Generation** — Automated billing with room charges, service charges, discounts, and payment tracking
- **Employee Management** — Staff roles and assignment to reservations/payments
- **Housekeeping Logs** — Room cleaning schedules and time tracking

### 📊 Data Analysis
- **Comprehensive EDA** — 20+ analytical questions covering data quality, univariate, and multivariate analysis
- **Cancellation Prediction** — Analysis of factors influencing booking cancellations
- **Revenue Analysis** — Seasonal trends, average daily rates, and booking lead times
- **Guest Segmentation** — Analysis by country, customer type, and booking channel

### 📈 Business Intelligence
- **Power BI Dashboard** — Interactive visualizations for hotel performance metrics
- **Orange Data Mining** — Visual workflow for predictive modeling
- **PDF Reports** — Documented analysis results and findings

---

## 🛠️ Technology Stack

| Category | Technology | Purpose |
|----------|-----------|---------|
| **Database** | SQL Server / MariaDB | Relational data storage and management |
| **Query Language** | T-SQL / MySQL | Data definition, manipulation, and analysis |
| **Data Analysis** | Python (Pandas, NumPy, Matplotlib, Seaborn) | Exploratory data analysis |
| **Notebooks** | Jupyter Notebook | Interactive analysis and documentation |
| **BI / Visualization** | Power BI | Interactive dashboards and reporting |
| **Data Mining** | Orange | Visual workflow for machine learning |
| **Version Control** | Git / GitHub | Source control and collaboration |

---

## 📁 Project Structure

```
Graduation project/
│
├── 📄 Hotel.sql                    # Original database schema (MariaDB/MySQL)
├── 📄 LAST Q.sql                   # Complete analytical queries
├── 📄 Quastions .sql               # Business questions and answers
│
├── 📁 trails/                      # Development iterations
│   ├── Creation DB.sql             # Database creation script (SQL Server)
│   ├── Final Prooo.sql             # Final production SQL script
│   ├── Employes*.sql               # Employee table iterations
│   ├── RoomTypes*.sql              # Room types data iterations
│   └── SQLQuery1*.sql              # Query development drafts
│
├── 📁 Insertaion/                  # Data insertion scripts
│   ├── Employee.sql                # Employee records (84K+ lines)
│   └── Room_Types.sql              # Room type configurations
│
├── 📁 DATA SET/                    # Raw data
│   └── hotel_booking.csv           # 119,390 hotel booking records (24MB)
│
├── 📁 EDA/                         # Exploratory Data Analysis
│   ├── Hotel_eda.ipynb             # Primary EDA notebook
│   └── hotel-eda (firest try).ipynb # Initial exploration draft
│
├── 📁 final/                       # Final deliverables
│   ├── Hotel_EDA_final.ipynb       # Comprehensive EDA (20 questions)
│   ├── LAST Q (1).sql              # Final SQL queries
│   ├── Quastions .sql              # Final business questions
│   ├── Hotel Reservation (1).pbix  # Power BI dashboard
│   ├── HOTEL RESERVATION...pdf     # Project report
│   ├── Orange results.pdf          # Data mining results
│   └── Hotel_Project_updated.ows   # Orange workflow file
│
├── 📁 answer Q/                    # Query result screenshots
│   └── Q1.png — Q102.png           # Visual query results
│
├── 📄 README.md                    # This file
├── 📄 LICENSE                      # MIT License
├── 📄 CONTRIBUTING.md              # Contribution guidelines
├── 📄 SECURITY.md                  # Security policy
└── 📄 .gitignore                   # Git ignore rules
```

---

## 🗃️ Database Schema

The database follows a normalized design with the following core entities:

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│  Employees   │     │   Guests     │     │  Room Types  │
│─────────────│     │──────────────│     │─────────────│
│ EmployeeID   │     │ GuestID      │     │ RoomTypeID   │
│ EmpName      │     │ FullName     │     │ TypeName     │
│ JobRole      │     │ NationalID   │     │ NightlyPrice │
└──────┬──────┘     │ Phone, Email │     └──────┬──────┘
       │            │ City         │            │
       │            └──────┬──────┘            │
       │                   │                   │
       │            ┌──────┴──────┐            │
       │            │ Reservations │            │
       │            │──────────────│            │
       └───────────►│ ReservationID│◄───────────┘
                    │ GuestID      │     ┌──────┴──────┐
                    │ RoomID       │────►│    Rooms     │
                    │ EmployeeID   │     │──────────────│
                    │ CheckIn/Out  │     │ RoomID       │
                    │ Status       │     │ RoomNumber   │
                    └──────┬──────┘     │ Availability │
                           │            └──────────────┘
                    ┌──────┴──────┐
                    │  Invoices    │
                    │──────────────│     ┌──────────────┐
                    │ InvoiceID    │────►│   Payments   │
                    │ TotalRoom    │     │──────────────│
                    │ TotalService │     │ PaymentID    │
                    │ Discount     │     │ AmountPaid   │
                    │ NetTotal     │     │ Method       │
                    └─────────────┘     └──────────────┘
```

### Key Tables

| Table | Description |
|-------|-------------|
| `Employees` | Hotel staff with roles |
| `RoomTypes` | Room categories and pricing |
| `Rooms` | Individual rooms with availability |
| `Guests` | Guest profiles and contact info |
| `Reservations` | Booking records with dates and status |
| `Services` | Ancillary services catalog |
| `ServiceUsages` | Services consumed per reservation |
| `Invoices` | Billing summaries |
| `Payments` | Payment transactions |
| `HousekeepingLogs` | Room cleaning records |

---

## 🚀 Installation

### Prerequisites

- **SQL Server 2019+** (or MariaDB 10.1+ for the MySQL version)
- **Python 3.8+** with Jupyter Notebook
- **Power BI Desktop** (for dashboard visualization)
- **Git** for version control

### Setup Steps

#### 1. Clone the Repository
```bash
git clone https://github.com/YOUR_USERNAME/hotel-property-management-system.git
cd hotel-property-management-system
```

#### 2. Database Setup (SQL Server)
```sql
-- Run the database creation script
sqlcmd -S your_server -i "trails/Creation DB.sql"

-- Insert data
sqlcmd -S your_server -d HotelReservation_BillingManagement -i "Insertaion/Employee.sql"
sqlcmd -S your_server -d HotelReservation_BillingManagement -i "Insertaion/Room_Types.sql"
```

#### 3. Python Environment (for EDA)
```bash
pip install pandas numpy matplotlib seaborn jupyter
cd final
jupyter notebook Hotel_EDA_final.ipynb
```

#### 4. Power BI Dashboard
Open `final/Hotel Reservation (1).pbix` in Power BI Desktop.

---

## 📖 Usage Guide

### Running SQL Queries
1. Connect to your SQL Server instance
2. Execute `trails/Creation DB.sql` to create the database schema
3. Run insertion scripts from `Insertaion/` folder
4. Execute queries from `LAST Q.sql` or `Quastions .sql`

### Exploratory Data Analysis
1. Navigate to the `final/` or `EDA/` directory
2. Open the Jupyter notebooks
3. Run cells sequentially — each section addresses specific analytical questions
4. The dataset (`DATA SET/hotel_booking.csv`) will be loaded automatically

### Power BI Dashboard
1. Open the `.pbix` file in Power BI Desktop
2. Refresh data connections if needed
3. Interact with filters and slicers for different views

---

## 📊 Data Analysis

The EDA notebook covers **20 comprehensive questions** organized into sections:

| Section | Topics | Questions |
|---------|--------|-----------|
| **A. Dataset Overview** | Data types, dimensions, structure | Q1–Q3 |
| **B. Data Quality** | Missing values, outliers, cleaning | Q4–Q9 |
| **C. Univariate Analysis** | Distributions, frequencies | Q10–Q14 |
| **D. Multivariate Analysis** | Correlations, relationships | Q15–Q19 |
| **E. Final Reporting** | Key findings and insights | Q20 |

### Key Findings
- Analysis of **119,390** hotel booking records
- Cancellation patterns and contributing factors
- Seasonal demand fluctuations
- Guest segmentation by country and customer type
- Revenue optimization opportunities

---

## 🔮 Future Enhancements

- [ ] **Web Application** — Full-stack web interface for hotel staff
- [ ] **REST API** — Backend API for integration with other systems
- [ ] **Real-time Dashboard** — Live monitoring of room availability
- [ ] **Machine Learning** — Predictive models for cancellation prevention
- [ ] **Mobile App** — Guest-facing booking application
- [ ] **Multi-property Support** — Manage multiple hotel locations
- [ ] **Automated Reporting** — Scheduled email reports
- [ ] **Integration** — Connect with external booking platforms (Booking.com, Expedia)
- [ ] **Authentication** — Role-based access control system
- [ ] **Docker** — Containerized deployment

---

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📄 License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.

---

## 👤 Author

**Graduation Project — Hotel Property Management System**

- 📧 Contact: *[your-email@example.com]*
- 🔗 Repository: [hotel-property-management-system](https://github.com/YOUR_USERNAME/hotel-property-management-system)

---

<div align="center">

**⭐ If you find this project useful, please give it a star! ⭐**

*Built with SQL, Python, and a passion for data.*

</div>
