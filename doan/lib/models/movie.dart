class Movie {
  final int? id;
  final String name;
  final String description;
  final int duration;
  final String releaseDate;
  final String posterUrl;
  final double rating;

  Movie({
    this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.releaseDate,
    required this.posterUrl,
    required this.rating,
  });

  factory Movie.fromMap(Map<String, dynamic> map) => Movie(
    id: map['ID'],
    name: map['NAME'],
    description: map['DESCRIPTION'],
    duration: map['DURATION'],
    releaseDate: map['RELEASEDATE'],
    posterUrl: map['POSTERURL'],
    rating: map['RATING'],
  );

  Map<String, dynamic> toMap() => {
    'ID': id,
    'NAME': name,
    'DESCRIPTION': description,
    'DURATION': duration,
    'RELEASEDATE': releaseDate,
    'POSTERURL': posterUrl,
    'RATING': rating,
  };
}
