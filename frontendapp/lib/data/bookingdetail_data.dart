import '../models/bookingdetail.dart';

final List<BookingDetail> sampleBookingDetails = [
  // Booking ID 1, showtimeId: 1
  BookingDetail(id: 1, bookingId: 1, seatId: 1, price: 90000.0), // A1, phòng 1
  BookingDetail(id: 2, bookingId: 1, seatId: 3, price: 90000.0), // A3, phòng 1
  // Booking ID 2, showtimeId: 2
  BookingDetail(id: 3, bookingId: 2, seatId: 6, price: 90000.0), // A1, phòng 2
  // Booking ID 3, showtimeId: 3
  BookingDetail(id: 4, bookingId: 3, seatId: 7, price: 90000.0), // A2, phòng 2
  BookingDetail(id: 5, bookingId: 3, seatId: 9, price: 90000.0), // B1, phòng 2
  BookingDetail(id: 6, bookingId: 3, seatId: 6, price: 90000.0), // A1, phòng 2
];