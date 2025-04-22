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
    phonenumber VARCHAR(20),
    maxroom INT
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

INSERT INTO cinemas (name, city, coordinates, address, phonenumber, maxroom)
VALUES
    ('Galaxy Nguyễn Du', 'TP.HCM', '10.7790,106.6918', '116 Nguyễn Du, Quận 1, TP.HCM', '02838222888', 4),
    ('Galaxy Tân Bình', 'TP.HCM', '10.8012,106.6395', '246 Nguyễn Hồng Đào, Quận Tân Bình, TP.HCM', '02838496088', 5),
    ('Galaxy Quang Trung', 'TP.HCM', '10.8491,106.6239', '304A Quang Trung, Quận Gò Vấp, TP.HCM', '02839890188', 6),
    ('Galaxy Cần Thơ', 'Cần Thơ', '10.0321,105.7679', 'Lầu 4, TTTM Sense City, 1 Đại lộ Hòa Bình, Quận Ninh Kiều, Cần Thơ', '02923769888', 5),
    ('Galaxy Đà Nẵng', 'Đà Nẵng', '16.0678,108.2235', 'Tầng 3, TTTM Indochina Riverside Mall, 74 Bạch Đằng, Quận Hải Châu, Đà Nẵng', '02363829888', 4),
    ('Galaxy Linh Trung', 'TP.HCM', '10.8692,106.7796', 'Tầng 2, TTTM Vincom Thủ Đức, 216 Võ Văn Ngân, Quận Thủ Đức, TP.HCM', '02837202888', 6),
    ('Galaxy Huỳnh Tấn Phát', 'TP.HCM', '10.7395,106.7298', '1362 Huỳnh Tấn Phát, Quận 7, TP.HCM', '02838739888', 5),
    ('Galaxy Sala', 'TP.HCM', '10.7896,106.7525', 'Tầng 2, TTTM Takashimaya, 92-94 Nam Kỳ Khởi Nghĩa, Quận 1, TP.HCM', '02838233888', 7),
    ('Galaxy Bến Thành', 'TP.HCM', '10.7735,106.6982', 'Tầng 5, TTTM Vạn Hạnh Mall, 11 Sư Vạn Hạnh, Quận 10, TP.HCM', '02838651888', 4),
    ('Galaxy Hải Phòng', 'Hải Phòng', '20.8449,106.6881', 'Tầng 5, TTTM Vincom Plaza Lê Thánh Tông, 1 Lê Thánh Tông, Quận Ngô Quyền, Hải Phòng', '02253856888', 5);
    
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

INSERT INTO users (name, email, password, phonenumber, address, dateofbirth, createdat, isactive, rolename)
VALUES 
('Nguyen Van A', 'nguyenvana@example.com', 'password123', '0905123456', '123 Đường Láng, Hà Nội', '1990-05-15', '2025-04-21 14:30:00', 1, 0),
('Tran Thi B', 'tranthib@example.com', 'securepass456', '0987654321', '456 Nguyễn Huệ, TP.HCM', '1995-08-20', '2025-04-21 15:00:00', 1, 1);

INSERT INTO bookings (userid, showtimeid, bookingdate, totalprice, paymentmethod, paymentstatus, isactive)
VALUES 
(1, 1, '2025-04-21 10:30:00', 150000, 'CREDIT_CARD', 'COMPLETED', 1),
(2, 2, '2025-04-21 11:00:00', 200000, 'CASH', 'PENDING', 1);

INSERT INTO bookingdetails (bookingid, seatid, price)
VALUES 
(1, 1, 75000),
(1, 2, 75000),
(2, 3, 100000),
(2, 4, 100000);

INSERT INTO bookings (userid, showtimeid, bookingdate, totalprice, paymentmethod, paymentstatus, isactive)
VALUES 
(1, 147, '2024-04-21 10:30:00', 150000, 'CREDIT_CARD', 'COMPLETED', 1);

INSERT INTO bookingdetails (bookingid, seatid, price)
VALUES 
(4, 4704, 75000);