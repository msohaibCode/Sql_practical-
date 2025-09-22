-- 1️⃣ Create Database
CREATE DATABASE ECommerceDB;
USE ECommerceDB;

-- 2️⃣ Users Table
CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(30),
    LastName VARCHAR(30),
    Email VARCHAR(50) UNIQUE,
    Phone VARCHAR(20),
    City VARCHAR(30),
    JoinDate DATE
);

-- 3️⃣ Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Description TEXT,
    Price DECIMAL(10,2),
    StockQty INT,
    Category VARCHAR(30)
);

-- 4️⃣ Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending','Shipped','Delivered','Cancelled') DEFAULT 'Pending',
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 5️⃣ OrderItems Table
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    SubTotal DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 6️⃣ Payments Table
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    Amount DECIMAL(10,2),
    Method ENUM('Cash','CreditCard','BankTransfer'),
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- 7️⃣ Reviews Table
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    ProductID INT,
    Rating INT CHECK(Rating BETWEEN 1 AND 5),
    Comment VARCHAR(200),
    ReviewDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 8️⃣ Insert Sample Users
INSERT INTO Users (FirstName, LastName, Email, Phone, City, JoinDate) VALUES
('Ali', 'Khan', 'ali.khan@example.com', '03001234567', 'Karachi', '2025-09-01'),
('Sara', 'Malik', 'sara.malik@example.com', '03007654321', 'Lahore', '2025-09-05'),
('Bilal', 'Hussain', 'bilal.hussain@example.com', '03111223344', 'Islamabad', '2025-09-08');

-- 9️⃣ Insert Sample Products
INSERT INTO Products (Name, Description, Price, StockQty, Category) VALUES
('Laptop', 'HP Pavilion 15, 8GB RAM, 512GB SSD', 120000.00, 10, 'Electronics'),
('Mobile Phone', 'Samsung Galaxy S23', 180000.00, 15, 'Electronics'),
('Shoes', 'Nike Running Shoes', 9000.00, 20, 'Fashion'),
('Book', 'Learn SQL in 7 Days', 1500.00, 50, 'Books');

-- 🔟 Insert Sample Orders
INSERT INTO Orders (UserID, TotalAmount, Status) VALUES
(1, 120000.00, 'Pending'),
(2, 189000.00, 'Shipped');

-- 1️⃣1️⃣ Insert Sample OrderItems
INSERT INTO OrderItems (OrderID, ProductID, Quantity, SubTotal) VALUES
(1, 1, 1, 120000.00),
(2, 2, 1, 180000.00),
(2, 3, 1, 9000.00);

-- 1️⃣2️⃣ Insert Sample Payments
INSERT INTO Payments (OrderID, Amount, Method) VALUES
(1, 120000.00, 'CreditCard'),
(2, 189000.00, 'Cash');

-- 1️⃣3️⃣ Insert Sample Reviews
INSERT INTO Reviews (UserID, ProductID, Rating, Comment) VALUES
(1, 1, 5, 'Excellent laptop, very fast!'),
(2, 2, 4, 'Great phone but expensive'),
(3, 4, 5, 'Very useful SQL book!');

-- 1️⃣4️⃣ Example Queries
-- Show all orders with customer name
SELECT o.OrderID, u.FirstName, u.LastName, o.TotalAmount, o.Status
FROM Orders o
JOIN Users u ON o.UserID = u.UserID;

-- Show all products with available stock
SELECT Name, Price, StockQty FROM Products WHERE StockQty > 0;

-- Show reviews with product names
SELECT p.Name, r.Rating, r.Comment
FROM Reviews r
JOIN Products p ON r.ProductID = p.ProductID;

-- Show total sales per category
SELECT p.Category, SUM(oi.SubTotal) AS TotalSales
FROM OrderItems oi
JOIN Products p ON oi.ProductID = p.ProductID
GROUP BY p.Category;
