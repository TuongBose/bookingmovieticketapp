import '../models/seat.dart';

final List<Seat> sampleSeats = [
  // Phòng 1
  Seat(id: 1, roomId: 1, seatNumber: 'A1', isBooked: false),
  Seat(id: 2, roomId: 1, seatNumber: 'A2', isBooked: true),
  Seat(id: 3, roomId: 1, seatNumber: 'A3', isBooked: false),
  Seat(id: 4, roomId: 1, seatNumber: 'B1', isBooked: true),
  Seat(id: 5, roomId: 1, seatNumber: 'B2', isBooked: false),

  // Phòng 2
  Seat(id: 6, roomId: 2, seatNumber: 'A1', isBooked: false),
  Seat(id: 7, roomId: 2, seatNumber: 'A2', isBooked: false),
  Seat(id: 8, roomId: 2, seatNumber: 'A3', isBooked: true),
  Seat(id: 9, roomId: 2, seatNumber: 'B1', isBooked: false),
  Seat(id: 10, roomId: 2, seatNumber: 'B2', isBooked: true),
];
