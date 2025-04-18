import 'dart:convert';
import '../models/movie.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;

class MovieService {
  static const String _baseUrl = 'http://192.168.1.203:8080'; // Thay bằng IP của máy tính

  Future<List<Movie>> _fetchMovies(String endpoint) async {
    final url = Uri.parse('$_baseUrl/api/v1/movies/$endpoint');
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

  // thêm mới hàm getSimilarMovies
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    return await _fetchMovies('similar/$movieId');
  }
}
