import '../models/showtime.dart';

final List<Showtime> sampleShowtimes = [
  Showtime(
    id: 1,
    movieId: 950387,
    roomId: 1,
    showDate: DateTime.parse('2025-04-11'),
    startTime: DateTime.parse('2025-04-11 18:30:00'),
    price: 75000,
  ),
  Showtime(
    id: 2,
    movieId: 950387,
    roomId: 2,
    showDate: DateTime.parse('2025-04-10'),
    startTime: DateTime.parse('2025-04-10 20:00:00'),
    price: 80000,
  ),
  Showtime(
    id: 3,
    movieId: 950387,
    roomId: 1,
    showDate: DateTime.parse('2025-04-11'),
    startTime: DateTime.parse('2025-04-10 17:00:00'),
    price: 70000,
  ),
  Showtime(
    id: 4,
    movieId: 950387,
    roomId: 3,
    showDate: DateTime.parse('2025-04-11'),
    startTime: DateTime.parse('2025-04-10 21:00:00'),
    price: 85000,
  ),
];
