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

-- Seed Users (2 Organisers, 2 Participants)
INSERT INTO AppUser (FirstName, LastName, Email, PasswordHash, Role)
VALUES 
('Sarah', 'Naidoo', 'sarah.org@raceday.co.za', 'hash123', 'Organiser'),
('John', 'Smith', 'john.org@raceday.co.za', 'hash123', 'Organiser'),
('Thabo', 'Mokoena', 'thabo.p@mail.com', 'hash123', 'Participant'),
('Emma', 'Van Wyk', 'emma.vw@mail.com', 'hash123', 'Participant');
 
-- Seed Locations
INSERT INTO EventLocation (Province, City, VenueName)
VALUES 
('KwaZulu-Natal', 'Durban', 'Moses Mabhida Stadium'),
('Western Cape', 'Cape Town', 'Cape Town Stadium'),
('Gauteng', 'Johannesburg', 'FNB Stadium');
 
-- Seed Events (3 Events) based on SA culture
INSERT INTO Event (EventName, EventDate, OrganiserID, LocationID)
VALUES 
('Comrades Marathon 2026', '2026-06-14', 1, 1),
('Cape Town Cycle Tour 2026', '2026-03-08', 2, 2),
('Soweto Marathon 2026', '2026-11-01', 1, 3);
 
-- Seed Categories
INSERT INTO RaceCategory (EventID, CategoryName, Distance, EntryFee)
VALUES 
(1, 'Ultra Marathon', 89.00, 1200.00),
(2, 'Standard Route', 109.00, 850.00),
(2, 'Short Route', 42.00, 450.00),
(3, 'Full Marathon', 42.20, 350.00),
(3, 'Half Marathon', 21.10, 250.00);
 
-- Seed Registrations (Enrolments)
INSERT INTO Registration (UserID, CategoryID)
VALUES 
(3, 1), -- Thabo in Comrades
(4, 2), -- Emma in Cycle Tour Standard
(3, 4); -- Thabo in Soweto Full
 
-- Seed Results
INSERT INTO RaceResult (RegistrationID, FinishTime, OverallPosition)
VALUES 
(1, '07:45:12', 450),
(2, '04:12:00', 120);
GO