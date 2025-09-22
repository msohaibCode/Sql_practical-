-- 1️⃣ Create Database
CREATE DATABASE DonateHubDB;
USE DonateHubDB;

-- 2️⃣ Donors Table
CREATE TABLE Donors (
    DonorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(30),
    LastName VARCHAR(30),
    Email VARCHAR(50),
    Phone VARCHAR(20),
    City VARCHAR(30)
);

-- 3️⃣ Campaigns Table
CREATE TABLE Campaigns (
    CampaignID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(100),
    Description TEXT,
    GoalAmount DECIMAL(12,2),
    StartDate DATE,
    EndDate DATE
);

-- 4️⃣ Donations Table
CREATE TABLE Donations (
    DonationID INT PRIMARY KEY AUTO_INCREMENT,
    DonorID INT,
    CampaignID INT,
    Amount DECIMAL(12,2),
    DonationDate DATE,
    PaymentMethod VARCHAR(20),
    FOREIGN KEY (DonorID) REFERENCES Donors(DonorID),
    FOREIGN KEY (CampaignID) REFERENCES Campaigns(CampaignID)
);

-- 5️⃣ Beneficiaries Table
CREATE TABLE Beneficiaries (
    BeneficiaryID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Type VARCHAR(30), -- e.g., Individual, School, Hospital
    City VARCHAR(30),
    ContactInfo VARCHAR(50)
);

-- 6️⃣ Allocations Table
CREATE TABLE Allocations (
    AllocationID INT PRIMARY KEY AUTO_INCREMENT,
    CampaignID INT,
    BeneficiaryID INT,
    AmountAllocated DECIMAL(12,2),
    AllocationDate DATE,
    FOREIGN KEY (CampaignID) REFERENCES Campaigns(CampaignID),
    FOREIGN KEY (BeneficiaryID) REFERENCES Beneficiaries(BeneficiaryID)
);

-- 7️⃣ Insert Sample Donors
INSERT INTO Donors (FirstName, LastName, Email, Phone, City) VALUES
('Ali', 'Khan', 'ali.khan@example.com', '03001234567', 'Karachi'),
('Sara', 'Malik', 'sara.malik@example.com', '03007654321', 'Lahore'),
('Bilal', 'Hussain', 'bilal.hussain@example.com', '03111223344', 'Islamabad');

-- 8️⃣ Insert Sample Campaigns
INSERT INTO Campaigns (Title, Description, GoalAmount, StartDate, EndDate) VALUES
('Flood Relief 2025', 'Helping flood-affected families in Sindh', 500000.00, '2025-08-01', '2025-12-31'),
('School Supplies Drive', 'Providing books and bags for underprivileged children', 200000.00, '2025-09-01', '2025-10-15');

-- 9️⃣ Insert Sample Donations
INSERT INTO Donations (DonorID, CampaignID, Amount, DonationDate, PaymentMethod) VALUES
(1, 1, 10000.00, '2025-09-01', 'Bank Transfer'),
(2, 1, 25000.00, '2025-09-05', 'Credit Card'),
(3, 2, 5000.00, '2025-09-10', 'Cash');

-- 🔟 Insert Sample Beneficiaries
INSERT INTO Beneficiaries (Name, Type, City, ContactInfo) VALUES
('Ahmed Orphanage', 'Organization', 'Karachi', '021-1234567'),
('Noor Hospital', 'Hospital', 'Lahore', '042-7654321');

-- 1️⃣1️⃣ Insert Sample Allocations
INSERT INTO Allocations (CampaignID, BeneficiaryID, AmountAllocated, AllocationDate) VALUES
(1, 1, 20000.00, '2025-09-15'),
(1, 2, 15000.00, '2025-09-20'),
(2, 1, 5000.00, '2025-09-18');

-- 1️⃣2️⃣ Example Queries
-- Show all donors
SELECT * FROM Donors;

-- Show all donations for Flood Relief 2025
SELECT d.DonationID, dn.FirstName, dn.LastName, d.Amount, d.DonationDate
FROM Donations d
JOIN Donors dn ON d.DonorID = dn.DonorID
JOIN Campaigns c ON d.CampaignID = c.CampaignID
WHERE c.Title = 'Flood Relief 2025';

-- Show how much allocated to each beneficiary
SELECT b.Name, SUM(a.AmountAllocated) AS TotalReceived
FROM Allocations a
JOIN Beneficiaries b ON a.BeneficiaryID = b.BeneficiaryID
GROUP BY b.Name;

-- Show total collected vs goal for each campaign
SELECT c.Title, SUM(d.Amount) AS TotalDonated, c.GoalAmount
FROM Campaigns c
LEFT JOIN Donations d ON c.CampaignID = d.CampaignID
GROUP BY c.Title, c.GoalAmount;
