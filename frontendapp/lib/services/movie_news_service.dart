import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_news.dart';

class MovieNewsService {
  final String apiKey = '5fffce961921b470c26eb34749b33ce4';

  // Hàm lấy danh sách tin tức điện ảnh
  Future<List<MovieNews>> getMovieNews() async {
    // Giả lập dữ liệu (có thể thay bằng API thực nếu có)
    await Future.delayed(const Duration(seconds: 1));

    // Dữ liệu mẫu với movieId
    List<Map<String, dynamic>> mockNewsData = [
      {
        'id': 1,
        'title': '[Review] Địa Đạo Mặt Trời Trong Bóng Tối: Bản Anh Hùng Ca Kỉ Niệm 50 Năm Thống Nhất Đất Nước',
        'image_url': 'https://example.com/image1.jpg',
        'type': 'review',
        'publish_date': '2025-04-10',
        'movie_id': 12345,
      },
      {
        'id': 2,
        'title': '[Review] Âm Dương Lộ: Tốn Vinh Tài Xế Xe Cứu Thương Thông Qua Truyền Thuyết Đô Thị',
        'image_url': 'https://example.com/image2.jpg',
        'type': 'review',
        'publish_date': '2025-04-09',
        'movie_id': 67890,
      },
      {
        'id': 3,
        'title': 'Bồi Thêu Chuyện Về 11 Năm Tâm Huyết Với Địa Đạo: Mặt Trời Trong Bóng Tối',
        'image_url': 'https://example.com/image3.jpg',
        'type': 'article',
        'publish_date': '2025-04-08',
        'movie_id': 12345,
      },
      {
        'id': 4,
        'title': 'Tổng Hợp Oscar 2025: Arora Thắng Lớn',
        'image_url': 'https://example.com/image4.jpg',
        'type': 'news',
        'publish_date': '2025-04-07',
        'movie_id': null,
      },
    ];

    return mockNewsData.map((data) => MovieNews.fromJson(data)).toList();
  }

  //  tin tức theo loại (review, news, article)
  Future<List<MovieNews>> getMovieNewsByType(String type) async {
    final allNews = await getMovieNews();
    return allNews.where((news) => news.type == type).toList();
  }

  //  danh sách người nổi tiếng (tab Nhân vật)
  Future<List<Map<String, dynamic>>> getCelebrities() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'name': 'Chris Evans',
        'image_url': 'https://example.com/chris_evans.jpg',
        'description': 'Khác với Chris Hemsworth vẫn đang loay hoay trong hình tượng vị thần sấm sét, đã có người nhận...',
      },
      {
        'name': 'Margot Robbie',
        'image_url': 'https://example.com/margot_robbie.jpg',
        'description': 'Nữ diễn viên tài năng của Hollywood...',
      },
    ];
  }
}