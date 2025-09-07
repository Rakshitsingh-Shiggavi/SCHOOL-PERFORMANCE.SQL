-- Step 1: Create Database
CREATE DATABASE SchoolPerformance;

-- Use the Database
USE SchoolPerformance;

-- Step 2: Create Students Table
CREATE TABLE Students (
    StudentID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique student identifier
    FirstName VARCHAR(50),  -- Student's first name
    LastName VARCHAR(50),  -- Student's last name
    Gender ENUM('Male', 'Female', 'Other'),  -- Gender classification
    DOB DATE,  -- Date of birth
    GradeLevel VARCHAR(20),  -- Current grade or year
    EnrollmentDate DATE  -- Date when student joined
);

-- Step 3: Create Teachers Table
CREATE TABLE Teachers (
    TeacherID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique teacher identifier
    FirstName VARCHAR(50),  -- Teacher's first name
    LastName VARCHAR(50),  -- Teacher's last name
    Subject VARCHAR(50),  -- Subject specialization
    ExperienceYears INT  -- Years of teaching experience
);

-- Step 4: Create Courses Table
CREATE TABLE Courses (
    CourseID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique course identifier
    CourseName VARCHAR(100),  -- Course title
    TeacherID INT,  -- Instructor for the course
    Credits INT,  -- Number of credits
    FOREIGN KEY (TeacherID) REFERENCES Teachers(TeacherID)
);

-- Step 5: Create Grades Table
CREATE TABLE Grades (
    GradeID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique grade identifier
    StudentID INT,  -- Student who received the grade
    CourseID INT,  -- Course in which the grade was given
    GradeType ENUM('Exam', 'Assignment', 'Project', 'Other'),  -- Type of assessment
    Score DECIMAL(5,2),  -- Numeric grade score
    GradeDate DATE,  -- Date of grading
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Step 6: Create Attendance Table
CREATE TABLE Attendance (
    AttendanceID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique attendance record
    StudentID INT,  -- Student's ID
    CourseID INT,  -- Course ID
    AttendanceDate DATE,  -- Date of the class
    Status ENUM('Present', 'Absent', 'Late'),  -- Attendance status
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Step 7: Insert Sample Data
-- Insert Students
INSERT INTO Students (FirstName, LastName, Gender, DOB, GradeLevel, EnrollmentDate)
VALUES ('John', 'Doe', 'Male', '2005-08-15', 'Grade 10', '2020-09-01'),
       ('Jane', 'Smith', 'Female', '2004-06-20', 'Grade 11', '2019-09-01');

-- Insert Teachers
INSERT INTO Teachers (FirstName, LastName, Subject, ExperienceYears)
VALUES ('Alan', 'Turing', 'Mathematics', 10),
       ('Grace', 'Hopper', 'Computer Science', 15);

-- Insert Courses
INSERT INTO Courses (CourseName, TeacherID, Credits)
VALUES ('Mathematics', 1, 4),
       ('Computer Science', 2, 3);

-- Insert Grades
INSERT INTO Grades (StudentID, CourseID, GradeType, Score, GradeDate)
VALUES (1, 1, 'Exam', 85.5, '2024-01-15'),
       (2, 2, 'Assignment', 92.0, '2024-01-20');

-- Insert Attendance
INSERT INTO Attendance (StudentID, CourseID, AttendanceDate, Status)
VALUES (1, 1, '2024-01-15', 'Present'),
       (2, 2, '2024-01-15', 'Absent');

-- Step 8: Advanced Queries
-- 1. Calculate Average Scores for Each Course
SELECT c.CourseName, AVG(g.Score) AS AverageScore
FROM Grades g
JOIN Courses c ON g.CourseID = c.CourseID
GROUP BY c.CourseName;

-- 2. Attendance Impact on Performance
SELECT s.FirstName, s.LastName, COUNT(a.Status) AS TotalClasses, AVG(g.Score) AS AverageScore
FROM Attendance a
JOIN Grades g ON a.StudentID = g.StudentID
JOIN Students s ON a.StudentID = s.StudentID
WHERE a.Status = 'Present'
GROUP BY s.StudentID;

-- 3. Identify Top Performing Students per Course
SELECT s.FirstName, s.LastName, c.CourseName, MAX(g.Score) AS TopScore
FROM Grades g
JOIN Students s ON g.StudentID = s.StudentID
JOIN Courses c ON g.CourseID = c.CourseID
GROUP BY c.CourseName;

-- 4. Find Students with Low Attendance and Low Grades
SELECT s.FirstName, s.LastName, COUNT(a.Status) AS AbsentDays, AVG(g.Score) AS AverageScore
FROM Attendance a
JOIN Grades g ON a.StudentID = g.StudentID
JOIN Students s ON a.StudentID = s.StudentID
WHERE a.Status = 'Absent'
GROUP BY s.StudentID
HAVING AbsentDays > 3 AND AverageScore < 60;

-- 5. Ranking Students Based on Scores
SELECT s.FirstName, s.LastName, c.CourseName, g.Score,
       RANK() OVER (PARTITION BY c.CourseName ORDER BY g.Score DESC) AS Rank
FROM Grades g
JOIN Students s ON g.StudentID = s.StudentID
JOIN Courses c ON g.CourseID = c.CourseID;