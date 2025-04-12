import 'dart:convert';
import '../models/movie.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;

class MovieService {
  final String apiKey = '5fffce961921b470c26eb34749b33ce4';

  // Hàm lấy phim đang chiếu
  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey&language=vi-VN&page=1',
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
          director: director
        );

        movies.add(movie);
      }

      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Hàm lấy phim sắp chiếu
  Future<List<Movie>> getUpComing() async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey&language=vi-VN&page=1',
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
            director: director
        );

        movies.add(movie);
      }

      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Lấy giới hạn độ tuổi
  Future<String?> getAgeCertification(int movieId) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/$movieId/release_dates?api_key=${apiKey}',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;

      final country = results.firstWhere(
        (element) => element['iso_3166_1'] == 'US', // hoặc 'VN'
        orElse: () => null,
      );

      if (country != null && country['release_dates'] != null) {
        final releaseDates = country['release_dates'] as List;
        if (releaseDates.isNotEmpty) {
          return mapAgeRating(releaseDates.first['certification']);
        }
      }
    }
    return "ALL";
  }

  Future<int?> getMovieRunTime(int movieId) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/$movieId?api_key=${apiKey}&language=en-US',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['runtime'];
    } else {
      print("Lay runtime movie khong thanh cong");
      return null;
    }
  }

  // Hàm chuyển xác định độ tuổi chuẩn Mỹ sang chuẩn VN
  String mapAgeRating(String? certification) {
    switch (certification) {
      case 'G':
        return 'P'; // General - phù hợp mọi lứa tuổi
      case 'PG':
        return 'K'; // Parental Guidance - trẻ em cần người lớn
      case 'PG-13':
        return 'T13';
      case 'R':
        return 'T16';
      case 'NC-17':
        return 'C18'; // Không dành cho dưới 18
      default:
        return 'ALL';
    }
  }

  Future<List<String>?> getCasts(int movieId) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=${apiKey}',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['cast'];

      List<String> casts = [];
      for (var actor in results.take(5)) {
        String name = actor['name'];
        casts.add(name);
      }
      return casts;
    } else {
      return null;
    }
  }

  Future<String?> getDirector(int movieId) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=${apiKey}',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['crew'];

      String? name;
      for (var actor in results) {
        if(actor['job'] == "Director")
          {
            name = actor['name'];
            break;
          }
      }
      return name;
    } else {
      return null;
    }
  }



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

}
