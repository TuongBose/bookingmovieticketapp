class Seat {
  final int? id;
  final int roomId;
  final String seatNumber;
  final bool isBooked;

  Seat({
    this.id,
    required this.roomId,
    required this.seatNumber,
    required this.isBooked,
  });

  factory Seat.fromMap(Map<String, dynamic> map) => Seat(
    id: map['ID'],
    roomId: map['ROOMID'],
    seatNumber: map['SEATNUMBER'],
    isBooked: map['ISBOOKED'] == 1,
  );

  Map<String, dynamic> toMap() => {
    'ID': id,
    'ROOMID': roomId,
    'SEATNUMBER': seatNumber,
    'ISBOOKED': isBooked ? 1 : 0,
  };
}
