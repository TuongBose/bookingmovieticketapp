CREATE DATABASE bookingmovieticketapp;
USE bookingmovieticketapp;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    phonenumber VARCHAR(20),
    address VARCHAR(255),
    dateofbirth DATE NOT NULL,
    createdat DATETIME,
    isactive BIT DEFAULT 1,
    rolename BIT 
);

CREATE TABLE movies (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    duration INT,
    releasedate DATE NOT NULL,
    posterurl VARCHAR(255),
    bannerurl VARCHAR(255),
    agerating VARCHAR(10),
    voteaverage DECIMAL(3, 1) NOT NULL,
    director VARCHAR(255)
);

CREATE TABLE cinemas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    coordinates VARCHAR(50), -- Lưu tọa độ (latitude, longitude)
    address VARCHAR(255) NOT NULL,
    phonenumber VARCHAR(20)
);

CREATE TABLE rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cinemaid INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    seatcolumnmax INT NOT NULL,
    seatrowmax INT NOT NULL,
    FOREIGN KEY (cinemaid) REFERENCES cinemas(id) ON DELETE CASCADE
);

CREATE TABLE seats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roomid INT NOT NULL,
    seatnumber VARCHAR(10) NOT NULL,
    FOREIGN KEY (roomid) REFERENCES rooms(id) ON DELETE CASCADE
);

CREATE TABLE showtimes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    movieid INT NOT NULL,
    roomid INT NOT NULL,
    showdate DATE NOT NULL,
    starttime DATETIME NOT NULL,
    price INT NOT NULL,
    FOREIGN KEY (movieid) REFERENCES movies(id) ON DELETE CASCADE,
    FOREIGN KEY (roomid) REFERENCES rooms(id) ON DELETE CASCADE
);

CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userid INT NOT NULL,
    showtimeid INT NOT NULL,
    bookingdate DATETIME NOT NULL,
    totalprice INT NOT NULL,
    paymentmethod VARCHAR(50) NOT NULL,
    paymentstatus VARCHAR(50) NOT NULL,
    isactive BIT DEFAULT 1,
    FOREIGN KEY (userid) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (showtimeid) REFERENCES showtimes(id) ON DELETE CASCADE
);

CREATE TABLE bookingdetails (
    id INT AUTO_INCREMENT PRIMARY KEY,
    bookingid INT NOT NULL,
    seatid INT NOT NULL,
    price INT NOT NULL,
    FOREIGN KEY (bookingid) REFERENCES bookings(id) ON DELETE CASCADE,
    FOREIGN KEY (seatid) REFERENCES seats(id) ON DELETE CASCADE
);

CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    bookingid INT NOT NULL,
    totalprice INT NOT NULL,
    paymentmethod VARCHAR(50) NOT NULL,
    paymentstatus VARCHAR(50) NOT NULL,
    paymenttime DATETIME NOT NULL,
    FOREIGN KEY (bookingid) REFERENCES bookings(id) ON DELETE CASCADE
);

CREATE TABLE ratings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    movieid INT NOT NULL,
    userid INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 10),
    comment VARCHAR(255),
    createdat DATETIME,
    FOREIGN KEY (movieid) REFERENCES movies(id) ON DELETE CASCADE,
    FOREIGN KEY (userid) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE movienews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    imageurl VARCHAR(255),
    type VARCHAR(50) NOT NULL,
    publishdate DATE,
    content VARCHAR(255),
    movieid INT,
    FOREIGN KEY (movieid) REFERENCES movies(id) ON DELETE CASCADE
);

CREATE TABLE casts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    movieid INT NOT NULL,
    actorname VARCHAR(255) NOT NULL,
    FOREIGN KEY (movieid) REFERENCES movies(id) ON DELETE CASCADE
);

INSERT INTO users (name, email, password, phonenumber, address, dateofbirth, createdat, isactive, rolename)
VALUES
    ('Admin User', 'admin@example.com', 'hashed_password_admin', '0901234567', '123 Đường Láng, Hà Nội', '1985-01-01', '2025-04-01 10:00:00', 1, 1),
    ('Nguyen Van A', 'user1@example.com', 'hashed_password_1', '0901234568', '456 Nguyễn Trãi, TP.HCM', '1995-05-15', '2025-04-02 12:00:00', 1, 0),
    ('Tran Thi B', 'user2@example.com', 'hashed_password_2', '0901234569', '789 Lê Lợi, Đà Nẵng', '2000-08-20', '2025-04-03 15:00:00', 1, 0);
    
INSERT INTO bookingdetails (bookingid, seatid, price)
VALUES
    (1, 1, 120000),  -- Booking 1, Seat A1 (The Matrix)
    (1, 2, 120000),  -- Booking 1, Seat A2 (The Matrix)
    (2, 7, 150000),  -- Booking 2, Seat A1 (Inception)
    (2, 8, 150000);  -- Booking 2, Seat A2 (Inception)
    
INSERT INTO payments (bookingid, totalprice, paymentmethod, paymentstatus, paymenttime)
VALUES
    (1, 240000, 'Credit Card', 'Completed', '2025-04-14 10:05:00'),  -- Booking 1
    (2, 300000, 'Cash', 'Pending', '2025-04-14 11:05:00');          -- Booking 2

USE bookingmovieticketapp;
SELECT * FROM users;
SELECT * FROM movies;
SELECT * FROM casts;
SELECT * FROM cinemas;
SELECT * FROM rooms;
SELECT * FROM seats;
SELECT * FROM showtimes;
SELECT * FROM bookings;
SELECT * FROM bookingdetails;
SELECT * FROM payments;
SELECT * FROM ratings;
SELECT * FROM movienews;