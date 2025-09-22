-- 1️⃣ Create Database
CREATE DATABASE OnlineForumDB;
USE OnlineForumDB;

-- 2️⃣ Users Table
CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(30) UNIQUE,
    Email VARCHAR(50) UNIQUE,
    Password VARCHAR(100),
    JoinDate DATE,
    Reputation INT DEFAULT 0
);

-- 3️⃣ Posts Table
CREATE TABLE Posts (
    PostID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    Title VARCHAR(200),
    Content TEXT,
    PostType ENUM('Question', 'Answer'),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 4️⃣ Tags Table
CREATE TABLE Tags (
    TagID INT PRIMARY KEY AUTO_INCREMENT,
    TagName VARCHAR(30) UNIQUE,
    Description VARCHAR(100)
);

-- 5️⃣ PostTags Table (many-to-many)
CREATE TABLE PostTags (
    PostID INT,
    TagID INT,
    PRIMARY KEY (PostID, TagID),
    FOREIGN KEY (PostID) REFERENCES Posts(PostID),
    FOREIGN KEY (TagID) REFERENCES Tags(TagID)
);

-- 6️⃣ Votes Table
CREATE TABLE Votes (
    VoteID INT PRIMARY KEY AUTO_INCREMENT,
    PostID INT,
    UserID INT,
    VoteType ENUM('Upvote', 'Downvote'),
    FOREIGN KEY (PostID) REFERENCES Posts(PostID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 7️⃣ Comments Table
CREATE TABLE Comments (
    CommentID INT PRIMARY KEY AUTO_INCREMENT,
    PostID INT,
    UserID INT,
    CommentText VARCHAR(200),
    CommentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PostID) REFERENCES Posts(PostID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 8️⃣ Insert Sample Users
INSERT INTO Users (Username, Email, Password, JoinDate, Reputation) VALUES
('AliDev', 'ali@example.com', 'hashedpass1', '2025-09-01', 120),
('SaraCoder', 'sara@example.com', 'hashedpass2', '2025-09-05', 80),
('BilalTech', 'bilal@example.com', 'hashedpass3', '2025-09-10', 50);

-- 9️⃣ Insert Sample Posts (Questions + Answers)
INSERT INTO Posts (UserID, Title, Content, PostType) VALUES
(1, 'How to join two tables in SQL?', 'I am learning SQL. Can anyone explain JOINs with example?', 'Question'),
(2, NULL, 'You can use INNER JOIN or LEFT JOIN depending on your requirement.', 'Answer'),
(3, 'What is difference between React and Angular?', 'I am confused between choosing React or Angular for my project.', 'Question');

-- 🔟 Insert Tags
INSERT INTO Tags (TagName, Description) VALUES
('SQL', 'Structured Query Language'),
('React', 'JavaScript library for UI'),
('Angular', 'JavaScript framework'),
('Database', 'Data management systems');

-- 1️⃣1️⃣ Link Posts with Tags
INSERT INTO PostTags (PostID, TagID) VALUES
(1, 1), -- SQL Question
(1, 4), -- Database
(2, 1), -- Answer linked to SQL
(3, 2), -- React
(3, 3); -- Angular

-- 1️⃣2️⃣ Insert Votes
INSERT INTO Votes (PostID, UserID, VoteType) VALUES
(1, 2, 'Upvote'),
(1, 3, 'Upvote'),
(2, 1, 'Upvote'),
(3, 2, 'Downvote');

-- 1️⃣3️⃣ Insert Comments
INSERT INTO Comments (PostID, UserID, CommentText) VALUES
(1, 3, 'This is a helpful question!'),
(2, 1, 'Thanks for answering.'),
(3, 2, 'I prefer React for flexibility.');

-- 1️⃣4️⃣ Example Queries
-- Get all questions
SELECT * FROM Posts WHERE PostType = 'Question';

-- Get answers for Question ID 1
SELECT * FROM Posts WHERE PostType = 'Answer' AND PostID <> 1;

-- Count votes per post
SELECT PostID, 
       SUM(CASE WHEN VoteType='Upvote' THEN 1 ELSE 0 END) AS Upvotes,
       SUM(CASE WHEN VoteType='Downvote' THEN 1 ELSE 0 END) AS Downvotes
FROM Votes
GROUP BY PostID;

-- Show posts with their tags
SELECT p.PostID, p.Title, t.TagName
FROM Posts p
JOIN PostTags pt ON p.PostID = pt.PostID
JOIN Tags t ON pt.TagID = t.TagID;
