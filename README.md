# Library Management System

A comprehensive SQL-based Library Management System that handles books, authors, members, and transactions with advanced querying capabilities.

## 📚 Database Schema

### Tables Overview

#### 1. **Authors Table**
Stores information about book authors.
- `author_id` (INT, Primary Key, Auto Increment)
- `name` (VARCHAR(100), NOT NULL)
- `email` (VARCHAR(100))

#### 2. **Books Table**
Manages book inventory and details.
- `book_id` (INT, Primary Key, Auto Increment)
- `title` (VARCHAR(50), NOT NULL)
- `author_id` (INT, Foreign Key to Authors)
- `category` (VARCHAR(50), NOT NULL)
- `isbn` (VARCHAR(20), NOT NULL)
- `published_date` (DATE, NOT NULL)
- `price` (DECIMAL(10,2), NOT NULL)
- `available_copies` (INT, DEFAULT 0, NOT NULL)

#### 3. **Members Table**
Tracks library members and their information.
- `member_id` (INT, Primary Key, Auto Increment)
- `name` (VARCHAR(100), NOT NULL)
- `email` (VARCHAR(100), NOT NULL)
- `phone_number` (VARCHAR(15), NOT NULL)
- `membership_date` (DATE, NOT NULL)

#### 4. **Transactions Table**
Records book borrowing and returning activities.
- `transaction_id` (INT, Primary Key, Auto Increment)
- `member_id` (INT, Foreign Key to Members)
- `book_id` (INT, Foreign Key to Books)
- `borrow_date` (DATE, NOT NULL)
- `return_date` (DATE, NULLABLE)
- `fine_amount` (DECIMAL(10,2), DEFAULT 0)

## 🔗 Relationships

- **Authors 1:N Books** - One author can write multiple books
- **Books 1:N Transactions** - One book can be borrowed multiple times
- **Members 1:N Transactions** - One member can borrow multiple books

## 📊 Sample Data

### Authors Included:
- Arundhati Roy, Chetan Bhagat, Amish Tripathi, Ruskin Bond, Jhumpa Lahiri, Vikram Seth

### Sample Books:
- "The God of Small Things" (Fiction)
- "Five Point Someone" (Fiction) 
- "The Immortals of Meluha" (Mythology)
- "The Blue Umbrella" (Children)
- "The Namesake" (Fiction)
- "A Suitable Boy" (Fiction)

### Sample Members:
- Priya Sharma, Rahul Verma, Ananya Patel, Arjun Singh, Sneha Reddy, Vikram Kumar

## 🛠 Features & Queries

### 1. **Basic CRUD Operations**
- Insert new books, authors, and members
- Update book availability after borrow/return
- Delete inactive members
- View all table data

### 2. **Filtering & Search**
```sql
-- Available books
SELECT * FROM Books WHERE available_copies > 0;

-- Books published after 2015
SELECT * FROM Books WHERE YEAR(published_date) > 2015;

-- Top 5 most expensive books
SELECT * FROM Books ORDER BY price DESC LIMIT 5;

-- Science books under ₹500
SELECT * FROM Books WHERE category = 'Science' AND price < 500;
```

### 3. **Advanced Analytics**
```sql
-- Books by category count
SELECT category, COUNT(*) AS total_books FROM Books GROUP BY category;

-- Most borrowed book
SELECT b.book_id, b.title, COUNT(t.transaction_id) AS borrow_count
FROM Books b JOIN Transactions t ON b.book_id = t.book_id
GROUP BY b.book_id, b.title ORDER BY borrow_count DESC LIMIT 1;

-- Total fines collected
SELECT SUM(fine_amount) AS total_fines FROM Transactions;
```

### 4. **JOIN Operations**
```sql
-- Books with author names
SELECT b.book_id, b.title, a.name AS author_name
FROM Books b INNER JOIN Authors a ON b.author_id = a.author_id;

-- Members with their borrowed books
SELECT m.member_id, m.name, t.transaction_id, t.book_id
FROM Members m LEFT JOIN Transactions t ON m.member_id = t.member_id;

-- Books never borrowed
SELECT b.book_id, b.title FROM Books b 
LEFT JOIN Transactions t ON b.book_id = t.book_id
WHERE t.transaction_id IS NULL;
```

### 5. **Window Functions & Ranking**
```sql
-- Rank books by borrow count
SELECT book_id, title, borrow_count,
       RANK() OVER (ORDER BY borrow_count DESC) AS borrow_rank
FROM (
    SELECT b.book_id, b.title, COUNT(t.transaction_id) AS borrow_count
    FROM Books b LEFT JOIN Transactions t ON b.book_id = t.book_id
    GROUP BY b.book_id, b.title
) AS book_borrows;
```

### 6. **Business Intelligence**
```sql
-- Member activity status
SELECT m.member_id, m.name,
       CASE WHEN EXISTS (
           SELECT 1 FROM Transactions t 
           WHERE t.member_id = m.member_id 
           AND t.borrow_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
       ) THEN 'Active' ELSE 'Inactive' END AS Membership_Status
FROM Members m;

-- Book categorization by publication year
SELECT book_id, title, published_date,
       CASE 
           WHEN YEAR(published_date) > 2020 THEN 'New Arrival'
           WHEN YEAR(published_date) < 2000 THEN 'Classic' 
           ELSE 'Regular'
       END AS Book_Category
FROM Books;
```

## 🚀 Setup Instructions

1. **Create Database:**
```sql
CREATE DATABASE IF NOT EXISTS Library;
USE Library;
```

2. **Execute the complete SQL script** to create tables and insert sample data

3. **Run individual queries** as needed for specific operations

## 📈 Key Features

- **Data Integrity**: Foreign key constraints with CASCADE delete
- **Flexible Design**: Nullable return dates for ongoing transactions
- **Comprehensive Reporting**: Multiple analytical queries
- **User Management**: Member activity tracking and status
- **Inventory Management**: Real-time book availability updates

## 💡 Use Cases

- **Librarians**: Manage book inventory and member registrations
- **Members**: Track borrowing history and fines
- **Analysts**: Generate reports on popular books and member behavior
- **Administrators**: Monitor library performance and trends

This system provides a solid foundation for library operations with room for expansion including reservations, reviews, and advanced reporting features.
