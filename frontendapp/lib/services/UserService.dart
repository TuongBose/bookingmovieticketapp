import 'dart:convert';

import 'package:frontendapp/dtos/UserDTO.dart';
import 'package:frontendapp/dtos/UserLoginDTO.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/user.dart';

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

  Future<User> login(UserLoginDTO userLoginDTO) async {
    try {
      final url = Uri.parse('${Config.BASEURL}/api/v1/users/login');
      final response = await http.post(
        // Sửa thành http.post
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          // Thêm Content-Type
          'Accept': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userLoginDTO.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Kiểm tra dữ liệu trả về có phải là một đối tượng JSON không
        if (data is Map<String, dynamic>) {
          return User.fromJson(data); // Chuyển đổi trực tiếp thành User
        } else {
          throw Exception(
            'Invalid response format: Expected a single user object',
          );
        }
      } else {
        throw Exception(
          'Failed to login: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }
}
