import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/movie.dart';

class MovieService {
  static const String _baseUrl = 'http://192.168.1.67:8080'; // Thay bằng IP của máy tính

  Future<List<Movie>> _fetchMovies(String endpoint) async {
    final url = Uri.parse('$_baseUrl/api/v1/movies/$endpoint');
    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode == 200) {
        // Giải mã dữ liệu với UTF-8
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(decodedBody);
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

  Future<List<Movie>> getSimilarMovies(int movieId) async {
    return await _fetchMovies('similar/$movieId');
  }
}