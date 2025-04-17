import '../models/booking.dart';

final List<Booking> sampleBookings = [
  Booking(
    id: 1,
    userId: 1,
    showtimeId: 1,
    bookingDate: '2025-04-11',
    totalPrice: 180000.0,
    paymentMethod: 'Credit Card',
    paymentStatus: 'Completed',
    isActive: true
  ),
  Booking(
    id: 2,
    userId: 2,
    showtimeId: 2,
    bookingDate: '2025-04-12',
    totalPrice: 90000.0,
    paymentMethod: 'Mobile Payment',
    paymentStatus: 'Pending',
      isActive: true
  ),
  Booking(
    id: 3,
    userId: 1,
    showtimeId: 3,
    bookingDate: '2025-04-13',
    totalPrice: 270000.0,
    paymentMethod: 'Cash',
    paymentStatus: 'Completed',
      isActive: true
  ),
];