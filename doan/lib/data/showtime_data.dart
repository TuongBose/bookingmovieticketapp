import '../models/showtime.dart';

final List<Showtime> sampleShowtimes = [
  Showtime(
    id: 1,
    movieId: 1,
    roomId: 1,
    showDate: DateTime.parse('2025-04-10'),
    startTime: DateTime.parse('18:30'),
    price: 75000,
  ),
  Showtime(
    id: 2,
    movieId: 1,
    roomId: 2,
    showDate: DateTime.parse('2025-04-10'),
    startTime: DateTime.parse('20:00'),
    price: 80000,
  ),
  Showtime(
    id: 3,
    movieId: 2,
    roomId: 1,
    showDate: DateTime.parse('2025-04-11'),
    startTime: DateTime.parse('17:00'),
    price: 70000,
  ),
  Showtime(
    id: 4,
    movieId: 2,
    roomId: 3,
    showDate: DateTime.parse('2025-04-11'),
    startTime: DateTime.parse('21:00'),
    price: 85000,
  ),
];
