import 'package:frontendapp/screens/seat_selection_screen.dart';
import '../data/cinema_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../data/seat_data.dart';
import '../models/movie.dart';
import '../data/room_data.dart';
import '../data/showtime_data.dart';
import '../models/cinema.dart';
import '../models/room.dart';
import '../models/seat.dart';
import '../models/showtime.dart';
import '../services/MovieService.dart';
import '../services/movie_news_service.dart';
import '../screens/news_detail_screen.dart';
import '../models/movie_news.dart';
class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key, required this.movie, required this.selectedLocation});

  final Movie movie;
  final String selectedLocation;

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Cinema? selectedCinema;
  int selectedIndex = 0;
  DateTime selectedDate = DateTime.now();
  ScrollController _scrollController = ScrollController();
  double _titleOpacity = 0.0;
  final MovieService _movieService = MovieService();
  final MovieNewsService _newsService = MovieNewsService(); // Thêm MovieNewsService

  List<Cinema> getCinemasByMovie(int movieId) {
    final filteredCinemasByCity = sampleCinemas
        .where((c) =>
    widget.selectedLocation == "Toàn quốc" ||
        c.city == widget.selectedLocation)
        .toList();

    final cinemaIds = filteredCinemasByCity.map((c) => c.id).toSet();

    final roomIds = sampleRooms
        .where((room) => cinemaIds.contains(room.cinemaId))
        .map((room) => room.id)
        .toSet();

    final showtimeRoomIds = sampleShowtimes
        .where((s) => s.movieId == movieId && roomIds.contains(s.roomId))
        .map((s) => s.roomId)
        .toSet();

    final finalCinemaIds = sampleRooms
        .where((room) => showtimeRoomIds.contains(room.id))
        .map((room) => room.cinemaId)
        .toSet();

    final result = filteredCinemasByCity
        .where((c) => finalCinemaIds.contains(c.id))
        .toList();

    print("Selected Location: ${widget.selectedLocation}");
    print("Filtered Cinemas: ${result.map((c) => "${c.name} (${c.city})").toList()}");

    return result;
  }

  List<Showtime> getShowtimes(int movieId, int cinemaId, DateTime date) {
    final roomIds = sampleRooms
        .where((room) => room.cinemaId == cinemaId)
        .map((room) => room.id)
        .toList();

    return sampleShowtimes
        .where((show) =>
    show.movieId == movieId &&
        roomIds.contains(show.roomId) &&
        show.showDate.year == date.year &&
        show.showDate.month == date.month &&
        show.showDate.day == date.day)
        .toList();
  }

  Room getRoomById(int roomId) {
    return sampleRooms.firstWhere((room) => room.id == roomId);
  }

  List<Seat> getSeatsByRoomId(int roomId) {
    return sampleSeats.where((seat) => seat.roomId == roomId).toList();
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi_VN', null).then((_) {
      setState(() {});
    });

    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      setState(() {
        _titleOpacity = (offset > 180) ? 1.0 : 0.0;
      });
    });

    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            floating: false,
            backgroundColor: Colors.white,
            elevation: 0,
            title: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _titleOpacity,
              child: Center(
                child: Text(
                  widget.movie.name,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Quay lại',
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: () {},
                tooltip: 'Chia sẻ',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.movie.bannerUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.play_arrow,
                            size: 40,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                          tooltip: 'Xem trailer',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.movie.posterUrl,
                      height: 150,
                      width: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 150,
                        width: 100,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.movie.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.movie.voteAverage}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 16,
                                color: Colors.blue,
                              ),
                              label: const Text(
                                'Đánh Giá',
                                style: TextStyle(color: Colors.blue),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildInfoTag(
                              '${widget.movie.ageRating}',
                              Colors.redAccent,
                            ),
                            const SizedBox(width: 8),
                            _buildInfoTag(
                              '${widget.movie.duration} Phút',
                              Colors.grey,
                              icon: Icons.access_time,
                            ),
                            const SizedBox(width: 8),
                            _buildInfoTag(
                              DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.movie.releaseDate)),
                              Colors.grey,
                              icon: Icons.calendar_today,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: const [
                  Tab(text: 'Suất Chiếu'),
                  Tab(text: 'Thông Tin'),
                  Tab(text: 'Tin Tức'),
                ],
              ),
            ),
            pinned: true,
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSuatChieuTabContent(),
                _buildThongTinTabContent(widget.movie),
                _buildTinTucTabContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuatChieuTabContent() {
    final filteredCinemas = getCinemasByMovie(widget.movie.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.location_city),
                  label: Text(widget.selectedLocation),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Chọn rạp chiếu",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Flexible(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: filteredCinemas.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      final isSelected = selectedCinema == null;
                                      return ListTile(
                                        leading: const Icon(Icons.theaters),
                                        title: Text(
                                          'Tất cả rạp',
                                          style: TextStyle(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: isSelected ? Colors.blue : Colors.black,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectedCinema = null;
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    } else {
                                      final cinema = filteredCinemas[index - 1];
                                      final isSelected =
                                          cinema.name == selectedCinema?.name;
                                      return ListTile(
                                        leading: const Icon(Icons.local_movies),
                                        title: Text(
                                          cinema.name,
                                          style: TextStyle(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: isSelected ? Colors.blue : Colors.black,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectedCinema = cinema;
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Done",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.theaters),
                  label: Text(selectedCinema?.name ?? "Cinema"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(7, (index) {
                final date = DateTime.now().add(Duration(days: index));
                final isSelected = selectedIndex == index;
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      selectedDate = date;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          index == 0
                              ? 'Hôm nay'
                              : DateFormat('EEE', 'vi_VN').format(date),
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white : Colors.black54,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM').format(date),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              DateFormat("EEEE, 'ngày' dd 'tháng' MM yyyy", 'vi_VN')
                  .format(selectedDate),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: filteredCinemas.map((cinema) {
              if (selectedCinema != null && cinema.id != selectedCinema!.id) {
                return const SizedBox();
              }
              final showtimes = getShowtimes(widget.movie.id, cinema.id, selectedDate);
              if (showtimes.isEmpty) return const SizedBox();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cinema.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "2D PHỤ ĐỀ",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: showtimes.map((show) {
                      final time = TimeOfDay.fromDateTime(show.startTime);
                      return OutlinedButton(
                        onPressed: () {
                          final room = getRoomById(show.roomId);
                          final seats = getSeatsByRoomId(show.roomId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeatSelectionScreen(
                                room: room,
                                allSeats: seats,
                                showtime: show,
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          side: BorderSide(color: Colors.grey[400]!),
                          textStyle: const TextStyle(fontSize: 14),
                          foregroundColor: Colors.black87,
                        ),
                        child: Text(time.format(context)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTag(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 12, color: color),
          if (icon != null) const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThongTinTabContent(Movie movie) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nội dung phim',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            movie.description,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          _buildInfoRow('Đạo diễn:', '${widget.movie.director}'),
          _buildInfoRow('Diễn viên:', '${widget.movie.casts?.join(", ")}, ...'),
          _buildInfoRow('Thể loại:', 'Hành động, Phiêu lưu'),
          _buildInfoRow('Ngày phát hành:', DateFormat('dd/MM/yyyy').format(DateTime.parse(movie.releaseDate))),
          _buildInfoRow('Thời lượng:', '${movie.duration} phút'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  Widget _buildTinTucTabContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phim tương tự',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<Movie>>(
            future: _movieService.getSimilarMovies(widget.movie.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Text('Lỗi khi tải dữ liệu');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('Không có phim tương tự');
              }

              final relatedMovies = snapshot.data!;

              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: relatedMovies.length,
                  itemBuilder: (context, index) {
                    final movie = relatedMovies[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(
                              movie: movie,
                              selectedLocation: widget.selectedLocation,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                movie.posterUrl,
                                height: 100,
                                width: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 100,
                                    width: 150,
                                    color: Colors.grey,
                                    child: const Icon(Icons.broken_image),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              movie.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              movie.releaseDate ?? 'Không rõ',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Đọc thêm',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<MovieNews>>(
            future: _newsService.getMovieNews(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Text('Lỗi khi tải dữ liệu tin tức');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('Không có tin tức liên quan');
              }

              final relatedNews = snapshot.data!
                  .where((news) => news.movieId == widget.movie.id)
                  .toList();

              if (relatedNews.isEmpty) {
                return const Text('Không có tin tức liên quan');
              }

              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: relatedNews.length,
                  itemBuilder: (context, index) {
                    final news = relatedNews[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailScreen(news: news),
                          ),
                        );
                      },
                      child: Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                news.imageUrl,
                                height: 100,
                                width: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 100,
                                    width: 200,
                                    color: Colors.grey,
                                    child: const Icon(Icons.broken_image),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              news.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              news.publishDate ?? 'Không rõ',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}