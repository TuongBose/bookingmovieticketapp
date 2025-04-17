import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room.dart';
import '../models/seat.dart';

class RoomService {
  static const String _baseUrl = 'http://192.168.1.67:8080'; // Thay bằng IP của máy tính

  Future<Room> getRoomById(int roomId) async {
    final url = Uri.parse('$_baseUrl/api/v1/rooms/$roomId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Room.fromJson(data);
      } else {
        throw Exception('Failed to load room: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching room: $e');
    }
  }

  Future<List<Seat>> getSeatsByRoomId(int roomId) async {
    final url = Uri.parse('$_baseUrl/api/v1/rooms/$roomId/seats');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Seat.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load seats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching seats: $e');
    }
  }
}