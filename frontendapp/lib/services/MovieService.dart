import 'dart:convert';
import '../models/movie.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;

class MovieService {
  Future<List<Movie>> _fetchMovies(String endpoint) async {
    final url = Uri.parse('http://localhost:8080/api/v1/movies/$endpoint');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movies from $endpoint: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movies from $endpoint: $e');
    }
  }

  Future<List<Movie>> getNowPlaying() async {
    return await _fetchMovies('nowplaying');
  }

  Future<List<Movie>> getUpComing() async {
    return await _fetchMovies('upcoming');
  }

  /*
// thêm mới hàm getSimilarMovies
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/$movieId/similar?api_key=$apiKey&language=vi-VN&page=1',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      List<Movie> movies = [];
      for (var item in results) {
        final ageRating = await getAgeCertification(item['id']);
        final duration = await getMovieRunTime(item['id']);
        final casts = await getCasts(item['id']);
        final director = await getDirector(item['id']);

        Movie movie = Movie(
          id: item['id'],
          name: item['title'],
          description: item['overview'],
          releaseDate: item['release_date'],
          posterUrl: 'https://image.tmdb.org/t/p/w500${item['poster_path']}',
          bannerUrl: 'https://image.tmdb.org/t/p/w500${item['backdrop_path']}',
          voteAverage: item['vote_average'],
          ageRating: ageRating,
          duration: duration,
          casts: casts,
          director: director,
        );

        movies.add(movie);
      }

      return movies;
    } else {
      throw Exception('Failed to load similar movies');
    }
  }
*/
}
