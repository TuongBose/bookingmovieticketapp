import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../dtos/BookingDTO.dart';
import '../models/booking.dart';
import '../models/bookingdetail.dart';

class BookingService {
  Future<int> createBooking(BookingDTO bookingDTO) async {
    try {
      final url = Uri.parse('${Config.BASEURL}/api/v1/bookings');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(bookingDTO.toJson()),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['id']; // Giả sử API trả về ID của booking vừa tạo
      } else {
        throw Exception('Failed to create booking: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating booking: $e');
    }
  }

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