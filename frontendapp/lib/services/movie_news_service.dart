import '../models/movie_news.dart';

class MovieNewsService {
  final String apiKey = '5fffce961921b470c26eb34749b33ce4';

  // Hàm lấy danh sách tin tức điện ảnh
  Future<List<MovieNews>> getMovieNews() async {
    // Giả lập dữ liệu (có thể thay bằng API thực )
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
      {
        'id': 5,
        'title': '[Review] Mufasa: Vua Sư Tử - Hành Trình Trở Thành Huyền Thoại',
        'image_url': 'https://example.com/image5.jpg',
        'type': 'review',
        'publish_date': '2025-04-06',
        'movie_id': 54321,
      },
      {
        'id': 6,
        'title': 'Phim Việt Chiếu Tết 2025: Cuộc Đua Của Những Tên Tuổi Lớn',
        'image_url': 'https://example.com/image6.jpg',
        'type': 'news',
        'publish_date': '2025-04-05',
        'movie_id': null,
      },
      {
        'id': 7,
        'title': '[Review] Hành Tinh Cát: Phần 3 - Đỉnh Cao Của Khoa Học Viễn Tưởng',
        'image_url': 'https://example.com/image7.jpg',
        'type': 'review',
        'publish_date': '2025-04-04',
        'movie_id': 98765,
      },
      {
        'id': 8,
        'title': 'Diễn Viên Trẻ Việt Nam Nổi Bật Nhất 2025: Ai Sẽ Lên Ngôi?',
        'image_url': 'https://example.com/image8.jpg',
        'type': 'article',
        'publish_date': '2025-04-03',
        'movie_id': null,
      },
      {
        'id': 9,
        'title': 'LHP Cannes 2025: Phim Việt Gây Ấn Tượng Mạnh',
        'image_url': 'https://example.com/image9.jpg',
        'type': 'news',
        'publish_date': '2025-04-02',
        'movie_id': null,
      },
      {
        'id': 10,
        'title': '[Review] Kẻ Trộm Mặt Trăng 4: Hài Hước Nhưng Thiếu Sáng Tạo',
        'image_url': 'https://example.com/image10.jpg',
        'type': 'review',
        'publish_date': '2025-04-01',
        'movie_id': 45678,
      },
      {
        'id': 11,
        'title': 'Phim Siêu Anh Hùng 2025: Marvel Có Lấy Lại Phong Độ?',
        'image_url': 'https://example.com/image11.jpg',
        'type': 'news',
        'publish_date': '2025-03-31',
        'movie_id': null,
      },
      {
        'id': 12,
        'title': 'Hậu Trường Phim Địa Đạo: Những Bí Mật Chưa Từng Tiết Lộ',
        'image_url': 'https://example.com/image12.jpg',
        'type': 'article',
        'publish_date': '2025-03-30',
        'movie_id': 12345,
      },
    ];

    return mockNewsData.map((data) => MovieNews.fromJson(data)).toList();
  }

  // Hàm lấy tin tức theo loại (review, news, article)
  Future<List<MovieNews>> getMovieNewsByType(String type) async {
    final allNews = await getMovieNews();
    return allNews.where((news) => news.type == type).toList();
  }

  // Hàm lấy danh sách người nổi tiếng (tab Nhân vật)
  Future<List<Map<String, dynamic>>> getCelebrities() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'name': 'Chris Evans',
        'image_url': 'https://example.com/chris_evans.jpg',
        'description': 'Khác với Chris Hemsworth vẫn đang loay hoay trong hình tượng vị thần sấm sét, Chris Evans đã tìm được hướng đi mới sau Captain America...',
      },
      {
        'name': 'Margot Robbie',
        'image_url': 'https://example.com/margot_robbie.jpg',
        'description': 'Nữ diễn viên tài năng của Hollywood, nổi tiếng với vai Harley Quinn và các dự án sản xuất ấn tượng...',
      },
      {
        'name': 'Trần Nghĩa',
        'image_url': 'https://example.com/tran_nghia.jpg',
        'description': 'Nam diễn viên trẻ của Việt Nam, gây ấn tượng mạnh với vai chính trong Địa Đạo Mặt Trời Trong Bóng Tối...',
      },
      {
        'name': 'Zendaya',
        'image_url': 'https://example.com/zendaya.jpg',
        'description': 'Ngôi sao trẻ của Hollywood, nổi bật trong Hành Tinh Cát: Phần 3 và các dự án thời trang đình đám...',
      },
      {
        'name': 'Đạo diễn Trấn Thành',
        'image_url': 'https://example.com/tran_thanh.jpg',
        'description': 'Đạo diễn kiêm diễn viên Việt Nam, tiếp tục ghi dấu ấn với các dự án phim Tết 2025...',
      },
      {
        'name': 'Timothée Chalamet',
        'image_url': 'https://example.com/timothee_chalamet.jpg',
        'description': 'Diễn viên trẻ tài năng, tiếp tục gây sốt với vai diễn trong các bộ phim nghệ thuật tại Cannes 2025...',
      },
      {
        'name': 'Ngô Thanh Vân',
        'image_url': 'https://example.com/ngo_thanh_van.jpg',
        'description': 'Nữ diễn viên và nhà sản xuất Việt Nam, người đứng sau thành công của nhiều dự án phim Việt quốc tế...',
      },
      {
        'name': 'Anya Taylor-Joy',
        'image_url': 'https://example.com/anya_taylor_joy.jpg',
        'description': 'Nữ diễn viên nổi tiếng với vai diễn trong các bộ phim kinh dị và tâm lý, được săn đón tại Hollywood...',
      },
    ];
  }
}