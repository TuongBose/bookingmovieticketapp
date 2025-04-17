import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cinema.dart';

class CinemaService {
  static const String _baseUrl = 'http://192.168.1.67:8080'; // Thay bằng IP của máy chạy backend

  Future<List<Cinema>> getCinemas() async {
    final url = Uri.parse('$_baseUrl/api/v1/cinemas');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Cinema.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cinemas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cinemas: $e');
    }
  }
}