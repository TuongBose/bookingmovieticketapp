class Booking {
  final int id;
  final int userId;
  final int showtimeId;
  final String bookingDate;
  final double totalPrice;
  final String paymentMethod;
  final String paymentStatus;
  final bool isActive;

  Booking({
    required this.id,
    required this.userId,
    required this.showtimeId,
    required this.bookingDate,
    required this.totalPrice,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.isActive,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'],
    userId: json['userId'],
    showtimeId: json['showtimeId'],
    bookingDate: json['bookingDate'],
    totalPrice: json['totalPrice'].toDouble(),
    paymentMethod: json['paymentMethod'],
    paymentStatus: json['paymentStatus'],
    isActive: json['isActive'] == 1,
  );
}
