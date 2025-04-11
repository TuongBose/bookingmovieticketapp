import '../models/showtime.dart';

final List<Showtime> sampleShowtimes = [
  // Galaxy Nguyễn Du (TP.HCM, roomId: 1 và 2)
  Showtime(
    id: 1,
    movieId: 950387,
    roomId: 1,
    showDate: DateTime.now(),
    startTime: DateTime.now().add(const Duration(hours: 1)), // 1 giờ sau hiện tại
    price: 90000,
  ),
  Showtime(
    id: 2,
    movieId: 950387,
    roomId: 2,
    showDate: DateTime.now(),
    startTime: DateTime.now().add(const Duration(hours: 3)), // 3 giờ sau hiện tại
    price: 90000,
  ),

  // CGV Crescent Mall (TP.HCM, roomId: 3 và 4)
  Showtime(
    id: 3,
    movieId: 950387,
    roomId: 3,
    showDate: DateTime.now(),
    startTime: DateTime.now().add(const Duration(hours: 2)), // 2 giờ sau hiện tại
    price: 100000,
  ),
  Showtime(
    id: 4,
    movieId: 950387,
    roomId: 4,
    showDate: DateTime.now().add(const Duration(days: 1)), // Ngày mai
    startTime: DateTime.now().add(const Duration(days: 1, hours: 1)),
    price: 100000,
  ),

  // Lotte Cinema Gò Vấp (TP.HCM, roomId: 5 và 6)
  Showtime(
    id: 5,
    movieId: 950387,
    roomId: 5,
    showDate: DateTime.now(),
    startTime: DateTime.now().add(const Duration(hours: 4)), // 4 giờ sau hiện tại
    price: 85000,
  ),
  Showtime(
    id: 6,
    movieId: 950387,
    roomId: 6,
    showDate: DateTime.now().add(const Duration(days: 1)), // Ngày mai
    startTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
    price: 85000,
  ),

  // CGV Vĩnh Nghiêm (TP.HCM, roomId: 13 và 14)
  Showtime(
    id: 7,
    movieId: 950387,
    roomId: 13,
    showDate: DateTime.now(),
    startTime: DateTime.now().add(const Duration(hours: 5)), // 5 giờ sau hiện tại
    price: 95000,
  ),
  Showtime(
    id: 8,
    movieId: 950387,
    roomId: 14,
    showDate: DateTime.now().add(const Duration(days: 1)), // Ngày mai
    startTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
    price: 95000,
  ),

  // CGV Vincom Mega Mall (Hà Nội, roomId: 7)
  Showtime(
    id: 9,
    movieId: 1,
    roomId: 7,
    showDate: DateTime.now(),
    startTime: DateTime.now().add(const Duration(hours: 2)),
    price: 110000,
  ),

  // BHD Star Cineplex (Hà Nội, roomId: 9)
  Showtime(
    id: 10,
    movieId: 1,
    roomId: 9,
    showDate: DateTime.now(),
    startTime: DateTime.now().add(const Duration(hours: 3)),
    price: 100000,
  ),

  // Galaxy Đà Nẵng (Đà Nẵng, roomId: 11)
  Showtime(
    id: 11,
    movieId: 1,
    roomId: 11,
    showDate: DateTime.now(),
    startTime: DateTime.now().add(const Duration(hours: 1)),
    price: 90000,
  ),

  // Lotte Cinema Cần Thơ (Cần Thơ, roomId: 15)
  Showtime(
    id: 12,
    movieId: 1,
    roomId: 15,
    showDate: DateTime.now(),
    startTime: DateTime.now().add(const Duration(hours: 2)),
    price: 85000,
  ),
];
