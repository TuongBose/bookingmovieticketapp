class Showtime {
  final int? id;
  final int movieId;
  final int roomId;
  final String showDate;
  final String startTime;
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
    showDate: map['SHOWDATE'],
    startTime: map['STARTTIME'],
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
