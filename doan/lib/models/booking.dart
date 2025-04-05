class Booking {
  final int? id;
  final int userId;
  final int showtimeId;
  final String bookingDate;
  final double totalPrice;
  final String paymentMethod;
  final String paymentStatus;

  Booking({
    this.id,
    required this.userId,
    required this.showtimeId,
    required this.bookingDate,
    required this.totalPrice,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  factory Booking.fromMap(Map<String, dynamic> map) => Booking(
    id: map['ID'],
    userId: map['USERID'],
    showtimeId: map['SHOWTIMEID'],
    bookingDate: map['BOOKINGDATE'],
    totalPrice: map['TOTALPRICE'].toDouble(),
    paymentMethod: map['PAYMENTMETHOD'],
    paymentStatus: map['PAYMENTSTATUS'],
  );

  Map<String, dynamic> toMap() => {
    'ID': id,
    'USERID': userId,
    'SHOWTIMEID': showtimeId,
    'BOOKINGDATE': bookingDate,
    'TOTALPRICE': totalPrice,
    'PAYMENTMETHOD': paymentMethod,
    'PAYMENTSTATUS': paymentStatus,
  };
}
