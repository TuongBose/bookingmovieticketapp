class Room {
  final int? id;
  final int cinemaId;
  final String name;
  final String seatRows;
  final int seatRowMax;

  Room({
    this.id,
    required this.cinemaId,
    required this.name,
    required this.seatRows,
    required this.seatRowMax,
  });

  factory Room.fromMap(Map<String, dynamic> map) => Room(
    id: map['ID'],
    cinemaId: map['CINEMAID'],
    name: map['NAME'],
    seatRows: map['SEATROWS'],
    seatRowMax: map['SEATROWMAX'],
  );

  Map<String, dynamic> toMap() => {
    'ID': id,
    'CINEMAID': cinemaId,
    'NAME': name,
    'SEATROWS': seatRows,
    'SEATROWMAX': seatRowMax,
  };
}
