-- Create Database
CREATE DATABASE RaceDay_Database;
GO
USE RaceDay_Database;
GO
 
-- 1. AppUser Table
CREATE TABLE AppUser (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    Role VARCHAR(20) NOT NULL CHECK (Role IN ('Organiser', 'Participant'))
);
 
-- 2. EventLocation Table
CREATE TABLE EventLocation (
    LocationID INT IDENTITY(1,1) PRIMARY KEY,
    Province VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    VenueName VARCHAR(150) NOT NULL
);
 
-- 3. Event Table
CREATE TABLE Event (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    EventName VARCHAR(150) NOT NULL,
    EventDate DATE NOT NULL,
    OrganiserID INT NOT NULL,
    LocationID INT NOT NULL,
    FOREIGN KEY (OrganiserID) REFERENCES AppUser(UserID),
    FOREIGN KEY (LocationID) REFERENCES EventLocation(LocationID)
);
 
-- 4. RaceCategory Table
CREATE TABLE RaceCategory (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    CategoryName VARCHAR(100) NOT NULL,
    Distance DECIMAL(5,2) NOT NULL,
    EntryFee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (EventID) REFERENCES Event(EventID) ON DELETE CASCADE
);
 
-- 5. Registration Table
CREATE TABLE Registration (
    RegistrationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CategoryID INT NOT NULL,
    RegisteredAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES AppUser(UserID),
    FOREIGN KEY (CategoryID) REFERENCES RaceCategory(CategoryID)
);
 
-- 6. RaceResult Table
CREATE TABLE RaceResult (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    RegistrationID INT NOT NULL UNIQUE,
    FinishTime TIME NOT NULL,
    OverallPosition INT NOT NULL,
    FOREIGN KEY (RegistrationID) REFERENCES Registration(RegistrationID)
);