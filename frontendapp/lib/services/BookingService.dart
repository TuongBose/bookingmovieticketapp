import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/booking.dart';
import '../models/bookingdetail.dart';

class BookingService {
  Future<List<Booking>> getBookingsByShowtimeId(int showtimeId) async {
    final url = Uri.parse('${Config.BASEURL}/api/v1/bookings/showtimes/$showtimeId/bookings');
    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching bookings: $e');
    }
  }
}