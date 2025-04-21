import 'dart:convert';

import 'package:frontendapp/dtos/UserDTO.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class UserService {
  Future<void> createUser(UserDTO userDTO) async {
    try {
      final url = Uri.parse('${Config.BASEURL}/api/v1/users/register');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userDTO.toJson()),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        // Đọc thông báo lỗi từ body của response
        final errorData = jsonDecode(response.body);
        String errorMessage;

        if (errorData is List) {
          // Nếu body trả về là danh sách lỗi (như ["So dien thoai khong duoc bo trong"])
          errorMessage = errorData.isNotEmpty ? errorData[0] : 'Unknown error';
        } else if (errorData is Map && errorData.containsKey('message')) {
          // Nếu body trả về là JSON với trường "message"
          errorMessage = errorData['message'];
        } else {
          errorMessage = 'Failed to create user: ${response.statusCode}';
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      throw ('Tạo tài khoản không thành công: $e');
    }
  }
}
