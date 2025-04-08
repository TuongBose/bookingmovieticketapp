class Showtime {
  final int? id;
  final int movieId;
  final int roomId;
  final DateTime showDate;
  final DateTime startTime;
  final int price;

  Showtime({
    this.id,
    required this.movieId,
    required this.roomId,
    required this.showDate,
    required this.startTime,
    required this.price,
  });

  factory Showtime.fromMap(Map<String, dynamic> map) => Showtime(
    id: map['ID'],
    movieId: map['MOVIEID'],
    roomId: map['ROOMID'],
    showDate: DateTime.parse(map['SHOWDATE']),
    startTime: DateTime.parse(map['STARTTIME']),
    price: map['PRICE'],
  );

  Map<String, dynamic> toMap() => {
    'ID': id,
    'MOVIEID': movieId,
    'ROOMID': roomId,
    'SHOWDATE': showDate,
    'STARTTIME': startTime,
    'PRICE': price,
  };
} 
