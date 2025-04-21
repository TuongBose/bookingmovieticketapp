import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'package:frontendapp/models/bookingdetail.dart';

class BookingDetailService{
  Future<List<BookingDetail>> getBookingDetailsByBookingId(int bookingId) async {
    final url = Uri.parse('${Config.BASEURL}/api/v1/bookingdetails/$bookingId/details');
    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => BookingDetail.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load booking details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching booking details: $e');
    }
  }
}