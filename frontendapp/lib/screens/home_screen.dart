import 'dart:async';
import 'package:flutter/material.dart';
import '../models/cinema.dart';   // Giả sử bạn có file này
import '../screens/movie_detail_screen.dart'; // Giả sử bạn có file này
import '../services/CinemaService.dart';
import '../services/MovieService.dart';
import '../models/movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Movie> _moviesNowPlaying = [];
  List<Movie> _moviesUpComing = [];
  List<Cinema> _filteredCinemas = [];
  List<Cinema> _cinemas = [];

  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = "";
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentCardPage = 0;
  Timer? _timer;
  String _selectedLocation = "Toàn quốc";

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      // Tải danh sách phim
      MovieService movieService = MovieService();

      // Tải danh sách rạp
      CinemaService cinemaService = CinemaService();

      final results = await Future.wait([
        movieService.getNowPlaying(),
        movieService.getUpComing(),
        cinemaService.getCinemas(),
      ]);
      setState(() {
        _moviesNowPlaying = (results[0] as List<Movie>) ?? [];
        _moviesUpComing = (results[1] as List<Movie>) ?? [];
        _cinemas = (results[2] as List<Cinema>) ?? [];
        _filteredCinemas = _cinemas; // Khởi tạo _filteredCinemas từ API
        _isLoading = false;
      });

      _startAutoScroll();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Không thể tải dữ liệu: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void _startAutoScroll() {
    // ... (Giữ nguyên logic _startAutoScroll)
    if (_moviesNowPlaying.isNotEmpty) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (_pageController.hasClients) {
          int nextPage = (_currentCardPage + 1) % _moviesNowPlaying.length;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    // ... (Giữ nguyên logic dispose)
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
  // --- Kết thúc phần giữ nguyên ---


  Widget _buildTabItem(String title, int index) {
    // ... (Giữ nguyên logic _buildTabItem)
    final bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blue.shade700 : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  List<String> getUniqueCities() {
    // ... (Giữ nguyên logic getUniqueCities)
    final cities = _filteredCinemas.map((cinema) => cinema.city).toSet().toList();
    cities.insert(0, "Toàn quốc"); // Thêm "Toàn quốc" vào đầu danh sách
    return cities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // **THAY ĐỔI 1: Sử dụng SingleChildScrollView thay vì CustomScrollView**
      body: SingleChildScrollView(
        // **THAY ĐỔI 2: Sử dụng Column làm con trực tiếp**
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Đảm bảo các con giãn chiều ngang
          children: [
            // Khoảng cách trên cùng
            const SizedBox(height: 30),

            // Banner và chấm điều hướng (Không còn là Sliver)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // Banner
                  SizedBox(
                    height: 200,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentCardPage = index;
                        });
                      },
                      itemCount: _moviesNowPlaying.length>5?5:_moviesNowPlaying.length,
                      itemBuilder: (context, index) {
                        final movie = _moviesNowPlaying[index];
                        return _buildBannerItem(movie);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Chấm điều hướng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _moviesNowPlaying.length,
                          (index) => buildIndicatorDot(_currentCardPage == index),
                    ),
                  ),
                ],
              ),
            ),

            // Tab và Location (Không còn là Sliver)
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 12.0,
                right: 12.0,
                bottom: 8.0,
              ),
              child: Row(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTabItem('Đang chiếu', 0),
                        VerticalDivider(
                          width: 16,
                          thickness: 1,
                          color: Colors.grey.shade300,
                        ),
                        _buildTabItem('Sắp chiếu', 1),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Nút chọn địa điểm (Giữ nguyên logic bên trong)
                  TextButton.icon(
                    onPressed: () {
                      final cities = getUniqueCities();
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                          title: const Text('Chọn khu vực'),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children:
                              cities.map((city) {
                                return ListTile(
                                  title: Text(city),
                                  onTap: () {
                                    Navigator.pop(context, city);
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ).then((selectedCity) {
                        if (selectedCity != null) {
                          setState(() {
                            _selectedLocation = selectedCity;
                            // Lọc rạp theo thành phố (nếu cần)
                            if (_selectedLocation == "Toàn quốc") {
                              _filteredCinemas = _cinemas;
                            } else {
                              _filteredCinemas =
                                  _cinemas.where((cinema) => cinema.city == _selectedLocation,).toList();
                            }
                          });
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: Colors.blue.shade700,
                      backgroundColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                    ),
                    icon: Icon(
                      Icons.location_on,
                      color: Colors.blue.shade700,
                      size: 18,
                    ),
                    label: Text(
                      _selectedLocation,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Danh sách phim (Không còn là SliverFillRemaining)
            // **THAY ĐỔI 3: IndexedStack nằm trực tiếp trong Column**
            IndexedStack(
              index: _selectedIndex,
              children: [
                // **THAY ĐỔI 4: Gọi hàm build GridView đã được sửa đổi**
                buildMoviesNowPlayingGrid(),
                buildMoviesUpComingGrid(),
              ],
            ),
            const SizedBox(height: 20), // Thêm khoảng trống dưới cùng nếu cần
          ],
        ),
      ),
    );
  }

  // --- _buildBannerItem, buildIndicatorDot (GIỮ NGUYÊN) ---
  Widget _buildBannerItem(Movie movie) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => MovieDetailScreen(
              movie: movie,
              selectedLocation: _selectedLocation,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(movie.bannerUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container( // Lớp phủ Gradient
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            ),
          ),
          child: Padding( // Padding cho Text bên trong lớp phủ
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Khởi chiếu: ${movie.releaseDate}', // Hoặc thông tin khác
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIndicatorDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 10 : 8,
      height: isActive ? 10 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.black54 : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
  // --- Kết thúc phần giữ nguyên ---


  // **THAY ĐỔI 5: Sửa đổi các hàm build GridView**
  Widget buildMoviesUpComingGrid() {
    if (_isLoading) {
      // Hiển thị loading indicator với kích thước cố định để không làm nhảy layout
      return const Center(child: SizedBox(height: 100, child: CircularProgressIndicator()));
    }
    if (_moviesUpComing.isEmpty) {
      return const Center(child: Text("Không có phim sắp chiếu"));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        // **QUAN TRỌNG**
        shrinkWrap: true, // Cho phép GridView tự tính chiều cao
        physics: const NeverScrollableScrollPhysics(), // Ngăn GridView tự cuộn
        itemCount: _moviesUpComing.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Số cột
          childAspectRatio: 0.65, // Tỷ lệ chiều rộng/chiều cao của card
          crossAxisSpacing: 10, // Khoảng cách ngang
          mainAxisSpacing: 10, // Khoảng cách dọc
        ),
        itemBuilder: (context, index) {
          final movie = _moviesUpComing[index];
          return MovieCard(movie: movie, selectedLocation: _selectedLocation);
        },
      ),
    );
  }

  Widget buildMoviesNowPlayingGrid() {
    if (_isLoading) {
      return const Center(child: SizedBox(height: 100, child: CircularProgressIndicator()));
    }
    if (_moviesNowPlaying.isEmpty) {
      return const Center(child: Text("Không có phim đang chiếu"));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        // **QUAN TRỌNG**
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _moviesNowPlaying.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final movie = _moviesNowPlaying[index];
          return MovieCard(movie: movie, selectedLocation: _selectedLocation);
        },
      ),
    );
  }
}

// --- MovieCard (GIỮ NGUYÊN) ---
class MovieCard extends StatelessWidget {
  // ... (Giữ nguyên widget MovieCard)
  final Movie movie;
  final String selectedLocation;

  const MovieCard({super.key, required this.movie, required this.selectedLocation});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie, selectedLocation:selectedLocation)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie.posterUrl,
                    fit: BoxFit.cover,
                    frameBuilder: (
                        context,
                        child,
                        frame,
                        wasSynchronouslyLoaded,
                        ) {
                      if (wasSynchronouslyLoaded) return child;
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeOut,
                        child: child,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      // Widget hiển thị khi load ảnh lỗi
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.movie_creation_outlined,
                            color: Colors.grey[400],
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Rating (góc dưới phải)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange, // Hoặc màu khác
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 14),
                        const SizedBox(width: 3),
                        Text(
                          '${movie.voteAverage}', // Giả sử có voteAverage
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Age Rating (góc trên phải)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent, // Hoặc màu phù hợp
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${movie.ageRating}', // Giả sử có ageRating (T18, P, C16...)
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            movie.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          // Có thể thêm thông tin khác ở đây (ví dụ: ngày khởi chiếu)
        ],
      ),
    );
  }
}