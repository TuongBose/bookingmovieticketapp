class BookingDetail {
  final int? id;
  final int bookingId;
  final int seatId;
  final double price;

  BookingDetail({
    this.id,
    required this.bookingId,
    required this.seatId,
    required this.price,
  });

  factory BookingDetail.fromMap(Map<String, dynamic> map) => BookingDetail(
    id: map['ID'],
    bookingId: map['BOOKINGID'],
    seatId: map['SEATID'],
    price: map['PRICE'].toDouble(),
  );

  Map<String, dynamic> toMap() => {
    'ID': id,
    'BOOKINGID': bookingId,
    'SEATID': seatId,
    'PRICE': price,
  };
}
