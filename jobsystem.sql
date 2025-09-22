-- 1️⃣ Create Database
CREATE DATABASE JobPortalDB;
USE JobPortalDB;

-- 2️⃣ Users Table
CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(50),
    Email VARCHAR(50) UNIQUE,
    Phone VARCHAR(20),
    Role ENUM('Seeker','Employer'),
    City VARCHAR(30),
    JoinDate DATE
);

-- 3️⃣ Companies Table
CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Industry VARCHAR(50),
    City VARCHAR(30),
    Website VARCHAR(100)
);

-- 4️⃣ Jobs Table
CREATE TABLE Jobs (
    JobID INT PRIMARY KEY AUTO_INCREMENT,
    EmployerID INT,
    CompanyID INT,
    Title VARCHAR(50),
    Description TEXT,
    Location VARCHAR(30),
    Salary DECIMAL(10,2),
    JobType ENUM('Full-Time','Part-Time','Internship','Remote'),
    PostDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (EmployerID) REFERENCES Users(UserID),
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

-- 5️⃣ Applications Table
CREATE TABLE Applications (
    AppID INT PRIMARY KEY AUTO_INCREMENT,
    JobID INT,
    SeekerID INT,
    ApplyDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending','Reviewed','Accepted','Rejected') DEFAULT 'Pending',
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (SeekerID) REFERENCES Users(UserID)
);

-- 6️⃣ Resumes Table
CREATE TABLE Resumes (
    ResumeID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    FilePath VARCHAR(200),
    Skills VARCHAR(200),
    ExperienceYears INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 7️⃣ Reviews Table
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY AUTO_INCREMENT,
    CompanyID INT,
    UserID INT,
    Rating INT CHECK(Rating BETWEEN 1 AND 5),
    Comment VARCHAR(200),
    ReviewDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 8️⃣ Insert Sample Users
INSERT INTO Users (FullName, Email, Phone, Role, City, JoinDate) VALUES
('Ali Khan', 'ali.khan@example.com', '03001234567', 'Seeker', 'Karachi', '2025-09-01'),
('Sara Malik', 'sara.malik@example.com', '03007654321', 'Employer', 'Lahore', '2025-09-05'),
('Bilal Hussain', 'bilal.hussain@example.com', '03111223344', 'Seeker', 'Islamabad', '2025-09-08');

-- 9️⃣ Insert Sample Companies
INSERT INTO Companies (Name, Industry, City, Website) VALUES
('TechVision', 'IT Services', 'Lahore', 'www.techvision.com'),
('HealthPlus', 'Healthcare', 'Karachi', 'www.healthplus.org');

-- 🔟 Insert Sample Jobs
INSERT INTO Jobs (EmployerID, CompanyID, Title, Description, Location, Salary, JobType) VALUES
(2, 1, 'Software Engineer', 'Develop web applications using React & Node.js', 'Lahore', 120000.00, 'Full-Time'),
(2, 1, 'Intern Developer', 'Assist in coding and testing', 'Remote', 20000.00, 'Internship'),
(2, 2, 'Nurse', 'Provide patient care at hospital', 'Karachi', 50000.00, 'Full-Time');

-- 1️⃣1️⃣ Insert Sample Applications
INSERT INTO Applications (JobID, SeekerID, Status) VALUES
(1, 1, 'Pending'),
(2, 3, 'Reviewed');

-- 1️⃣2️⃣ Insert Sample Resumes
INSERT INTO Resumes (UserID, FilePath, Skills, ExperienceYears) VALUES
(1, '/resumes/ali_khan.pdf', 'Java, SQL, React', 2),
(3, '/resumes/bilal_hussain.pdf', 'Python, Django, ML', 1);

-- 1️⃣3️⃣ Insert Sample Reviews
INSERT INTO Reviews (CompanyID, UserID, Rating, Comment) VALUES
(1, 1, 5, 'Great company to work with!'),
(2, 3, 4, 'Good healthcare services');

-- 1️⃣4️⃣ Example Queries
-- Show all job posts with company name
SELECT j.Title, j.Location, j.Salary, c.Name AS CompanyName
FROM Jobs j
JOIN Companies c ON j.CompanyID = c.CompanyID;

-- Show all applications with job seeker name
SELECT a.AppID, u.FullName AS Seeker, j.Title, a.Status
FROM Applications a
JOIN Users u ON a.SeekerID = u.UserID
JOIN Jobs j ON a.JobID = j.JobID;

-- Show average rating of each company
SELECT c.Name, AVG(r.Rating) AS AvgRating
FROM Reviews r
JOIN Companies c ON r.CompanyID = c.CompanyID
GROUP BY c.Name;
