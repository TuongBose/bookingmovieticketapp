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

  factory Showtime.fromJson(Map<String, dynamic> json) => Showtime(
    id: json['id'],
    movieId: json['movieId'],
    roomId: json['roomId'],
    showDate: DateTime.parse(json['showDate']),
    startTime: DateTime.parse(json['startTime']),
    price: json['price'],
  );
} 
