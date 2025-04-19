import 'dart:convert';
import 'package:http/http.dart' as http;import '../config.dart';

import '../models/cinema.dart';

class CinemaService {
  Future<List<Cinema>> getCinemas() async {
    final url = Uri.parse('${Config.BASEURL}/api/v1/cinemas');
    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json; charset=UTF-8'},
      );
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