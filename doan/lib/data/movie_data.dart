import '../models/movie.dart';

final List<Movie> sampleMovies = [
  Movie(
    id: 1,
    name: 'Mai',
    description: 'Trái tim đầy sẹo của Mai bỗng như được chữa lành và khao khát được sống khác đi khi Dương tiến vào cuộc đời cô. Nhưng tình yêu của họ vẫn sẽ vẹn nguyên khi miệng đời lắm cay nghiệt, bất công?',
    duration: 131 ,
    releaseDate: DateTime.parse('2024-01-01'),
    posterUrl: 'assets/images/movies/mai_poster.webp',
    bannerUrl: 'assets/images/movies/mai_banner.jpg',
    age: 18,
    rating: 8.5,
  ),
  Movie(
    id: 2,
    name: 'Bộ tứ báo thủ',
    description: 'Bộ tứ báo thủ bao gồm Chét-Xi-Cà, Dì Bốn, Cậu Mười Một, Con Kiều chính thức xuất hiện cùng với phi vụ báo thế kỉ. Nghe nói kế hoạch tiếp theo là ở Đà Lạt, liệu bốn báo thủ sẽ quậy Tết tung nóc cỡ nào?',
    duration: 132,
    releaseDate: DateTime.parse('2025-09-21'),
    posterUrl: 'assets/images/movies/botubaothu_poster.jpg',
    bannerUrl: 'assets/images/movies/mai_banner.jpg',
    age: 18,
    rating: 8.8,
  ),
];