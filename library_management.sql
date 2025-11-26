-- CREATE DATABASE
CREATE DATABASE Library;
USE Library;

-- CREATE TABLES OF Authors
CREATE TABLE Authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100)
);

-- CREATE TABLES OF books
CREATE TABLE books (
	book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50) NOT NULL,
    author_id INT NOT NULL,
    category VARCHAR(50) NOT NULL,
    isbn VARCHAR(20) NOT NULL,
    published_date DATE NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    available_copies INT DEFAULT 0 NOT NULL, 
	FOREIGN KEY (author_id) REFERENCES Authors(author_id)  
);

-- CREATE TABLES OF Members
CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    membership_date DATE NOT NULL
);

-- CREATE TABLES OF Transactions
CREATE TABLE Transactions (
    transaction_id  INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    borrow_date DATE NOT NULL,
    return_date DATE NOT NULL,
    fine_amount DECIMAL(10,2) DEFAULT 0,
	FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- Insert sample data into Authors table 
INSERT INTO Authors (name, email) VALUES
('Arundhati Roy', 'aroy@email.com'),
('Chetan Bhagat', 'chetanbhagat@email.com'),
('Amish Tripathi', 'amish@email.com'),
('Ruskin Bond', 'ruskinbond@email.com'),
('Jhumpa Lahiri', 'jlahiri@email.com'),
('Vikram Seth', 'vikramseth@email.com');

-- Insert sample data into Books table 
INSERT INTO Books (title, author_id, category, isbn, published_date, price, available_copies) VALUES
('The God of Small Things', 1, 'Fiction', '978-0-06-097749-8', '1997-01-01', 450.00, 8),
('Five Point Someone', 2, 'Fiction', '978-8-12-911630-0', '2004-01-01', 200.00, 12),
('The Immortals of Meluha', 3, 'Mythology', '978-9-33-035622-0', '2010-01-01', 300.00, 6),
('The Blue Umbrella', 4, 'Children', '978-8-12-911490-0', '1980-01-01', 150.00, 15),
('The Namesake', 5, 'Fiction', '978-0-39-332921-5', '2003-01-01', 350.00, 7),
('A Suitable Boy', 6, 'Fiction', '978-0-06-078652-6', '1993-01-01', 600.00, 4),
('New Book2' , 2, 'Friction', 'ISBN0010', '2016-01-01', 550.00, 0),
('New Book', 3,'Science', 'ISBN008', '2016-01-01', 450.00, 2);

-- Insert sample data into Members table 
INSERT INTO Members (name, email, phone_number, membership_date) VALUES
('Priya Sharma', 'priya.sharma@gmail.com', '9876543210', '2022-01-15'),
('Rahul Verma', 'rahul.verma@yahoo.com', '9876543211', '2013-02-20'),
('Ananya Patel', 'ananya.patel@email.com', '9876543212', '2012-03-10'),
('Arjun Singh', 'arjun.singh@email.com', '9876543213', '2019-01-08'),
('Sneha Reddy', 'sneha.reddy@email.com', '9876543214', '2023-04-05'),
('Vikram Kumar', 'vikram.kumar@email.com', '9876543215', '2023-02-28');

-- Insert sample data into Transactions table
INSERT INTO Transactions (member_id, book_id, borrow_date, return_date, fine_amount) VALUES
(1, 1, '2024-01-10', '2024-01-24', 0.00),
(2, 3, '2024-01-15', '2024-02-01', 35.00),
(3, 5, '2024-01-12', '2024-01-26', 0.00),
(4, 2, '2024-01-18', '2024-02-05', 52.50),
(5, 6, '2024-01-20', '2024-02-03', 0.00),
(6, 4, '2024-01-22', '2024-02-08', 27.50);


-- 1. Insert new book, Authors, and members in data base.
INSERT INTO Books (author_id, title, category, isbn, published_date, price, available_copies)


VALUES (1, 'New Book', 'Science', 'ISBN008', '2016-01-01', 550.00, 2);

INSERT INTO Authors (name, email)
VALUES ('New Author', 'newauthor@example.com');

INSERT INTO Members (name, email, phone_number, membership_date)
VALUES ('New Member', 'newmember@example.com', '9999999999', '2024-08-01');
 
 -- View Books table
 SELECT * FROM Books;
 
 -- UPDATE book availability after borrow 
UPDATE Books SET available_copies = available_copies - 1 WHERE book_id = 3;

-- UPDATE book availability after return 
UPDATE Books SET available_copies = available_copies + 1 WHERE book_id = 3;

 -- View members table
 SELECT * FROM Members;
 
  -- View Transactions table
 SELECT * FROM Transactions;

-- DELETE members who haven’t borrowed in the last 1 year
DELETE FROM Members
WHERE member_id NOT IN (
    SELECT DISTINCT member_id
    FROM Transactions
    WHERE borrow_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);

-- RETRIEVE all books with available copies
SELECT * FROM Books WHERE available_copies > 0;

-- 2. Books published AFTER 2015
SELECT * FROM Books WHERE YEAR(published_date) > 2015;

-- Top 5 most expensive books
SELECT * FROM Books ORDER BY price DESC;

-- Members who joined BEFORE 2022
SELECT * FROM Members WHERE membership_date < '2022-01-01';

-- 3. Science books with price < 500
SELECT * FROM Books WHERE category = 'Science' AND price < 500;

-- Books NOT available for borrowing
SELECT * FROM Books WHERE available_copies = 0;

-- Members who joined after 2020 OR have borrowed > 3 books
SELECT m.member_id, m.name, COUNT(t.transaction_id) AS total_borrowed
FROM Members m
LEFT JOIN Transactions t 
    ON m.member_id = t.member_id
GROUP BY m.member_id, m.name
HAVING 
    MAX(m.membership_date > '2020-12-31') = 1
    OR COUNT(t.transaction_id) > 3;


-- 4 Books sorted alphabetically
SELECT * FROM Books ORDER BY title ASC;

-- Number of books borrowed by each member
SELECT m.member_id, m.name, COUNT(t.transaction_id) AS total_borrowed
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id
GROUP BY m.member_id, m.name;

-- Group books by category and show total count
SELECT category, COUNT(*) AS total_books FROM Books GROUP BY category;

-- 5. Total number of books in each category
SELECT category, COUNT(*) AS total_books FROM Books GROUP BY category;

-- Average price of books
SELECT AVG(price) AS avg_price FROM Books;

-- Most borrowed book
SELECT b.book_id, b.title, COUNT(t.transaction_id) AS borrow_count
FROM Books b
JOIN Transactions t ON b.book_id = t.book_id
GROUP BY b.book_id, b.title
ORDER BY borrow_count DESC
LIMIT 1;


-- Total fines collected
SELECT SUM(fine_amount) AS total_fines FROM Transactions;

-- 6. Foreign Keys

--  Link Books to Authors
ALTER TABLE Books 
ADD CONSTRAINT fk_books_authors
FOREIGN KEY (author_id) REFERENCES Authors(author_id);

--  Link Transactions to Members
ALTER TABLE Transactions 
ADD CONSTRAINT fk_transactions_members
FOREIGN KEY (member_id) REFERENCES Members(member_id);

--  Link Transactions to Books
ALTER TABLE Transactions 
ADD CONSTRAINT fk_transactions_books
FOREIGN KEY (book_id) REFERENCES Books(book_id);

-- 7. INNER JOIN: books with their author names
SELECT b.book_id, b.title, a.name AS author_name
FROM Books b
INNER JOIN Authors a ON b.author_id = a.author_id;

-- LEFT JOIN: members and any books they borrowed
SELECT m.member_id, m.name, t.transaction_id, t.book_id
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id;

-- RIGHT JOIN: books that haven’t been borrowed
SELECT b.book_id, b.title
FROM Transactions t
RIGHT JOIN Books b ON t.book_id = b.book_id
WHERE t.transaction_id IS NULL;

-- FULL OUTER JOIN equivalent: members who NEVER borrowed
SELECT m.*
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id
WHERE t.transaction_id IS NULL;


-- 8. Books borrowed by members who registered AFTER 2022
SELECT DISTINCT b.*
FROM Books b
JOIN Transactions t ON b.book_id = t.book_id
WHERE t.member_id IN (
    SELECT member_id
    FROM Members
    WHERE membership_date > '2022-12-31'
);

-- Most borrowed book using a subquery
SELECT *
FROM (
    SELECT b.book_id, b.title, COUNT(t.transaction_id) AS borrow_count
    FROM Books b
    JOIN Transactions t ON b.book_id = t.book_id
    GROUP BY b.book_id, b.title
) AS x
ORDER BY borrow_count DESC
LIMIT 1;

-- Members who have never borrowed a book (subquery style)
SELECT * FROM Members WHERE member_id NOT IN ( SELECT DISTINCT member_id FROM Transactions);


-- 9. Count books by publication YEAR
SELECT YEAR(published_date) AS pub_year, COUNT(*) AS total_book FROM Books GROUP BY YEAR(published_date);

-- Difference in days between borrow and return
SELECT transaction_id, member_id, book_id, borrow_date, return_date, DATEDIFF(return_date, borrow_date) AS days_taken
FROM Transactions
WHERE return_date IS NOT NULL;

-- Borrow date formatted as DD-MM-YYYY
SELECT transaction_id, DATE_FORMAT(borrow_date, '%d-%m-%Y') AS borrow_date_formatted
FROM Transactions;


-- Book titles in UPPERCASE
SELECT UPPER(title) AS upper_title FROM Books;

-- Trim whitespace from author names
SELECT TRIM(name) AS trimmed_name FROM Authors;

-- Replace missing email with 'Not Provided'
SELECT name, IFNULL(email, 'Not Provided') AS email_display FROM Members;

-- 11. Rank books by number of times borrowed
SELECT book_id, title, borrow_count, RANK() OVER (ORDER BY borrow_count DESC) AS borrow_rank
FROM (
    SELECT b.book_id, b.title, COUNT(t.transaction_id) AS borrow_count
    FROM Books b
    LEFT JOIN Transactions t ON b.book_id = t.book_id
    GROUP BY b.book_id, b.title
) AS x;

-- Cumulative number of books borrowed per member (over time)
SELECT member_id, borrow_date, daily_count, SUM(daily_count) OVER (PARTITION BY member_id ORDER BY borrow_date) AS cumulative_borrowed
FROM (
    SELECT member_id, borrow_date, COUNT(*) AS daily_count
    FROM Transactions
    GROUP BY member_id, borrow_date
) AS t
ORDER BY member_id, borrow_date;

-- Moving 3-month average of books borrowed
SELECT borrow_month, total_borrowed,
       AVG(total_borrowed) OVER (
           ORDER BY borrow_month
           RANGE INTERVAL 2 MONTH PRECEDING
       ) AS moving_avg_3_months
FROM (
    SELECT DATE_FORMAT(borrow_date, '%Y-%m-01') AS borrow_month,
           COUNT(*) AS total_borrowed
    FROM Transactions
    GROUP BY DATE_FORMAT(borrow_date, '%Y-%m-01')
) AS m
ORDER BY borrow_month;


-- 12. Membership_Status: Active if borrowed in last 6 months, else Inactive
SELECT m.member_id, m.name,
       CASE
           WHEN EXISTS (
               SELECT 1
               FROM Transactions t
               WHERE t.member_id = m.member_id
                 AND t.borrow_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
           ) THEN 'Active'
           ELSE 'Inactive'
       END AS Membership_Status
FROM Members m;

-- Categorize books by publication year
SELECT b.book_id, b.title, b.published_date,
       CASE
           WHEN YEAR(published_date) > 2020  THEN 'New Arrival'
           WHEN YEAR(published_date) < 2000  THEN 'Classic'
           ELSE 'Regular'
       END AS Book_Category
FROM Books b;




