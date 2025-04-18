class Movie {
  final int id;
  final String name;
  final String description;
  final int duration;
  final String releaseDate;
  final String posterUrl;
  final String bannerUrl;
  final String ageRating;
  final double voteAverage;
  final List<String>? casts;
  final String? director;

  Movie({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.releaseDate,
    required this.posterUrl,
    required this.bannerUrl,
    required this.ageRating,
    required this.voteAverage,
    this.casts,
    this.director
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      duration: json['duration'],
      releaseDate: json['releasedate'],
      posterUrl: json['posterurl'],
      bannerUrl: json['bannerurl'],
      ageRating: json['agerating'],
      voteAverage: (json['voteaverage'] as num).toDouble(),
      casts: json['casts'] != null
          ? (json['casts'] as List).map((cast) => cast['actorname'] as String).toList()
          : null,
      director: json['director'],
    );
  }
}
