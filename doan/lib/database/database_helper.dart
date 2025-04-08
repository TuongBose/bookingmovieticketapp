import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'movie_booking.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // USERS
        await db.execute('''
          CREATE TABLE USERS (
            ID INTEGER PRIMARY KEY,
            NAME TEXT,
            EMAIL TEXT,
            PASSWORD TEXT,
            PHONENUMBER TEXT,
            ADDRESS TEXT,
            DATEOFBIRTH DATETIME,
            CREATEDAT DATETIME,
            ISACTIVE BOOLEAN,
            ROLENAME BOOLEAN
          )
        ''');

        // MOVIES
        await db.execute('''
          CREATE TABLE MOVIES (
            ID INTEGER PRIMARY KEY,
            NAME TEXT,
            DESCRIPTION TEXT,
            DURATION INTEGER,
            RELEASEDATE DATETIME,
            POSTERURL TEXT,
            BANNERURL TEXT,
            AGE INTEGER,
            RATING FLOAT
          )
        ''');

        // CINEMAS
        await db.execute('''
          CREATE TABLE CINEMAS (
            ID INTEGER PRIMARY KEY,
            NAME TEXT,
            LOCATION TEXT,
            PHONENUMBER TEXT
          )
        ''');

        // ROOMS
        await db.execute('''
          CREATE TABLE ROOMS (
            ID INTEGER PRIMARY KEY,
            CINEMAID INTEGER,
            NAME TEXT,
            SEATROWS TEXT,
            SEATROWMAX INTEGER,
            FOREIGN KEY(CINEMAID) REFERENCES CINEMAS(ID)
          )
        ''');

        // SHOWTIMES
        await db.execute('''
          CREATE TABLE SHOWTIMES (
            ID INTEGER PRIMARY KEY,
            MOVIEID INTEGER,
            ROOMID INTEGER,
            SHOWDATE DATETIME,
            STARTTIME DATETIME,
            PRICE INTEGER,
            FOREIGN KEY(MOVIEID) REFERENCES MOVIES(ID),
            FOREIGN KEY(ROOMID) REFERENCES ROOMS(ID)
          )
        ''');

        // SEATS
        await db.execute('''
          CREATE TABLE SEATS (
            ID INTEGER PRIMARY KEY,
            ROOMID INTEGER,
            SEATNUMBER TEXT,
            ISBOOKED BIT,
            FOREIGN KEY(ROOMID) REFERENCES ROOMS(ID)
          )
        ''');

        // BOOKINGS
        await db.execute('''
          CREATE TABLE BOOKINGS (
            ID INTEGER PRIMARY KEY,
            USERID INTEGER,
            SHOWTIMEID INTEGER,
            BOOKINGDATE DATETIME,
            TOTALPRICE FLOAT,
            PAYMENTMETHOD TEXT,
            PAYMENTSTATUS TEXT,
            FOREIGN KEY(USERID) REFERENCES USERS(ID),
            FOREIGN KEY(SHOWTIMEID) REFERENCES SHOWTIMES(ID)
          )
        ''');

        // BOOKINGDETAILS
        await db.execute('''
          CREATE TABLE BOOKINGDETAILS (
            ID INTEGER PRIMARY KEY,
            BOOKINGID INTEGER,
            SEATID INTEGER,
            PRICE FLOAT,
            FOREIGN KEY(BOOKINGID) REFERENCES BOOKINGS(ID),
            FOREIGN KEY(SEATID) REFERENCES SEATS(ID)
          )
        ''');

        // PAYMENTS
        await db.execute('''
          CREATE TABLE PAYMENTS (
            ID INTEGER PRIMARY KEY,
            BOOKINGID INTEGER,
            TOTALPRICE FLOAT,
            PAYMENTMETHOD TEXT,
            PAYMENTSTATUS TEXT,
            PAYMENTTIME DATETIME,
            FOREIGN KEY(BOOKINGID) REFERENCES BOOKINGS(ID)
          )
        ''');

        // RATINGS
        await db.execute('''
          CREATE TABLE RATINGS (
            ID INTEGER PRIMARY KEY,
            MOVIEID INTEGER,
            USERID INTEGER,
            RATING INTEGER,
            COMMENT TEXT,
            CREATEDAT DATETIME,
            FOREIGN KEY(MOVIEID) REFERENCES MOVIES(ID),
            FOREIGN KEY(USERID) REFERENCES USERS(ID)
          )
        ''');
      },
    );
  }
}
