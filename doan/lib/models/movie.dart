class Movie {
  final int id;
  final String name;
  final String description;
  final int? duration;
  final String releaseDate;
  final String posterUrl;
  final String bannerUrl;
  final String? ageRating;
  final double voteAverage;
  final List<String>? casts;
  final String? director;

  Movie({
    required this.id,
    required this.name,
    required this.description,
    this.duration,
    required this.releaseDate,
    required this.posterUrl,
    required this.bannerUrl,
    this.ageRating,
    required this.voteAverage,
    this.casts,
    this.director
  });
}
