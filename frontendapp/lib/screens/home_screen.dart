import 'dart:async';
import 'package:flutter/material.dart';
import '../data/cinema_data.dart';
import '../models/cinema.dart';
import '../screens/movie_detail_screen.dart';
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

  bool _isLoading = true;
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentCardPage = 0;
  Timer? _timer;
  String _selectedLocation = "Toàn quốc";

  void loadMovies() async {
    MovieService movieService = MovieService();
    final moviesNowPlaying = await movieService.getNowPlaying();
    final moviesUpComing = await movieService.getUpComing();
    setState(() {
      _moviesNowPlaying = moviesNowPlaying;
      _moviesUpComing = moviesUpComing;
      _filteredCinemas = sampleCinemas;
      _isLoading = false;
      _startAutoScroll();
    });
  }

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  void _startAutoScroll() {
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
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildTabItem(String title, int index) {
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
    final cities = sampleCinemas.map((cinema) => cinema.city).toSet().toList();
    cities.insert(0, "Toàn quốc"); // Thêm "Toàn quốc" vào đầu danh sách
    return cities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Khoảng cách trên cùng
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          // Banner và chấm điều hướng
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // Banner
                  SizedBox(
                    height: 200,
                    child:
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentCardPage = index;
                                });
                              },
                              itemCount: _moviesNowPlaying.length,
                              itemBuilder: (context, index) {
                                final movie = _moviesNowPlaying[index];
                                return _buildBannerItem(movie);
                              },
                            ),
                  ),
                  SizedBox(height: 10),
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
          ),
          // Tab
          SliverToBoxAdapter(
            child: Padding(
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
                              _filteredCinemas = sampleCinemas;
                            } else {
                              _filteredCinemas =
                                  sampleCinemas
                                      .where(
                                        (cinema) =>
                                            cinema.city == _selectedLocation,
                                      )
                                      .toList();
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
          ),
          // Danh sách phim
          SliverFillRemaining(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                buildMoviesNowPlayingGrid(),
                buildMoviesUpComingGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            ),
          ),
          child: Padding(
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
                  'Khởi chiếu: ${movie.releaseDate}',
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

  Widget buildMoviesUpComingGrid() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: _moviesUpComing.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final movie = _moviesUpComing[index];
          return MovieCard(movie: movie, selectedLocation: _selectedLocation,);
        },
      ),
    );
  }

  Widget buildMoviesNowPlayingGrid() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: _moviesNowPlaying.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final movie = _moviesNowPlaying[index];
          return MovieCard(movie: movie, selectedLocation: _selectedLocation,);
        },
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
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
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 14),
                        const SizedBox(width: 3),
                        Text(
                          '${movie.voteAverage}',
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
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${movie.ageRating}',
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
        ],
      ),
    );
  }
}
