import 'package:frontendapp/screens/seat_selection_screen.dart';

import '../data/cinema_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart'; // Thêm thư viện intl để định dạng ngày tháng
import '../data/seat_data.dart';
import '../models/movie.dart';

import '../data/room_data.dart';
import '../data/showtime_data.dart';
import '../models/cinema.dart';
import '../models/room.dart';
import '../models/seat.dart';
import '../models/showtime.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key, required this.movie, required this.selectedLocation});

  final Movie movie; // Nhận movie object từ HomeScreen
  final String selectedLocation;

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

// Thêm SingleTickerProviderStateMixin để dùng cho TabController
class _MovieDetailScreenState extends State<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Cinema? selectedCinema;
  int selectedIndex = 0;
  DateTime selectedDate = DateTime.now();
  ScrollController _scrollController = ScrollController();
  double _titleOpacity = 0.0;

  // Lấy danh sách cinemas theo movie và thành phố đã chọn
  List<Cinema> getCinemasByMovie(int movieId) {
    // Bước 1: Lọc danh sách rạp theo thành phố đã chọn
    final filteredCinemasByCity = sampleCinemas
        .where((c) =>
    widget.selectedLocation == "Toàn quốc" ||
        c.city == widget.selectedLocation)
        .toList();

    // Bước 2: Lấy danh sách cinemaIds từ các rạp đã lọc
    final cinemaIds = filteredCinemasByCity.map((c) => c.id).toSet();

    // Bước 3: Lấy danh sách roomIds từ các rạp đã lọc
    final roomIds = sampleRooms
        .where((room) => cinemaIds.contains(room.cinemaId))
        .map((room) => room.id)
        .toSet();

    // Bước 4: Lấy danh sách suất chiếu của phim tại các phòng đã lọc
    final showtimeRoomIds = sampleShowtimes
        .where((s) => s.movieId == movieId && roomIds.contains(s.roomId))
        .map((s) => s.roomId)
        .toSet();

    // Bước 5: Lấy lại danh sách cinemaIds từ các roomIds có suất chiếu
    final finalCinemaIds = sampleRooms
        .where((room) => showtimeRoomIds.contains(room.id))
        .map((room) => room.cinemaId)
        .toSet();

    // Bước 6: Trả về danh sách rạp cuối cùng
    final result = filteredCinemasByCity
        .where((c) => finalCinemaIds.contains(c.id))
        .toList();

    // Debug
    print("Selected Location: ${widget.selectedLocation}");
    print("Filtered Cinemas: ${result.map((c) => "${c.name} (${c.city})").toList()}");

    return result;
  }

  // Lấy suất chiếu theo phim, rạp, ngày
  List<Showtime> getShowtimes(int movieId, int cinemaId, DateTime date) {
    final roomIds =
    sampleRooms
        .where((room) => room.cinemaId == cinemaId)
        .map((room) => room.id)
        .toList();

    return sampleShowtimes
        .where(
          (show) =>
      show.movieId == movieId &&
          roomIds.contains(show.roomId) &&
          show.showDate.year == date.year &&
          show.showDate.month == date.month &&
          show.showDate.day == date.day,
    )
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
    // Khởi tạo DateFormatting
    initializeDateFormatting('vi_VN', null).then((_) {
      setState(() {
        // Lúc này bạn có thể dùng DateFormat với 'vi_VN'
      });
    });
    
    // Khởi tạo ScrollController
    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      setState(() {
        // Tùy ngưỡng: ví dụ sau khi scroll > 180px thì hiện tiêu đề
        _titleOpacity = (offset > 180) ? 1.0 : 0.0;
      });
    });

    // Khởi tạo TabController
    _tabController = TabController(
      length: 3,
      vsync: this,
    ); // 3 tabs: Suất chiếu, Thông tin, Tin tức
  }

  @override
  void dispose() {
    _tabController.dispose(); // Hủy controller khi widget bị hủy
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Định dạng ngày tháng (cần import 'package:intl/intl.dart';)
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      // Sử dụng CustomScrollView để có hiệu ứng co dãn header
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          // 1. App Bar co dãn với ảnh nền lớn
          SliverAppBar(
            expandedHeight: 250.0,
            // Chiều cao tối đa của ảnh nền
            pinned: true,
            // Giữ App Bar luôn hiển thị khi cuộn lên
            floating: false,
            backgroundColor: Colors.white,
            // Màu nền khi co lại
            elevation: 0,
            // Bỏ shadow
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
              // Nút Back
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Quay lại',
            ),
            actions: [
              // Nút Share
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: () {
                  /* Xử lý sự kiện share */
                },
                tooltip: 'Chia sẻ',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Ảnh nền lớn
                  Image.network(
                    // Hoặc Image.network nếu URL từ mạng
                    widget.movie.bannerUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Colors.grey,
                        ), // Placeholder khi lỗi ảnh
                  ),
                  // Lớp phủ màu tối dần (gradient) để chữ dễ đọc hơn
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
                  // Nút Play ở giữa (tùy chọn)
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
                          onPressed: () {
                            /* Xử lý sự kiện xem trailer */
                          },
                          tooltip: 'Xem trailer',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Không cần title ở đây vì thông tin phim sẽ nằm bên dưới
              // title: Text(widget.movie.name, style: TextStyle(color: Colors.white, fontSize: 16.0)),
              // titlePadding: EdgeInsets.only(left: 16.0, bottom: 16.0),
            ),
          ),

          // 2. Phần thông tin chính của phim (nằm ngay dưới AppBar)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ảnh Poster nhỏ
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      // Hoặc Image.network
                      widget.movie.posterUrl,
                      height: 150, // Chiều cao cố định cho poster
                      width: 100, // Chiều rộng cố định
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            height: 150,
                            width: 100,
                            color: Colors.grey[300],
                          ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Cột chứa thông tin bên phải poster
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên phim
                        Text(
                          widget.movie.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Rating và nút Đánh giá
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
                            const Spacer(), // Đẩy nút Đánh giá sang phải
                            TextButton.icon(
                              onPressed: () {
                                /* Xử lý sự kiện đánh giá */
                              },
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
                        // Thông tin Tag (Tuổi, Thời lượng, Ngày chiếu)
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
                        // Có thể thêm thể loại ở đây nếu có
                        // const SizedBox(height: 8),
                        // Text("Thể loại: Hành động, Phiêu lưu", style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Thanh Tab (dùng SliverPersistentHeader để nó "dính" lại khi cuộn)
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              // Helper class bên dưới
              TabBar(
                controller: _tabController,
                // Gán controller
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
            pinned: true, // Giữ TabBar luôn hiển thị
          ),

          // 4. Nội dung của các Tab (dùng SliverFillRemaining hoặc SliverList/SliverToBoxAdapter)
          SliverFillRemaining(
            // Chiếm hết phần còn lại
            hasScrollBody: true, // Quan trọng: để cuộn chính quản lý
            child: TabBarView(
              controller: _tabController, // Gán controller
              children: [
                // Nội dung Tab "Suất Chiếu" (sẽ xây dựng chi tiết hơn)
                _buildSuatChieuTabContent(),
                // Nội dung Tab "Thông Tin"
                _buildThongTinTabContent(widget.movie),
                // Nội dung Tab "Tin Tức"
                Center(child: Text('Nội dung Tin Tức (chưa có)')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget xây dựng nội dung cho Tab "Suất Chiếu" (hiện tại là placeholder)
  Widget _buildSuatChieuTabContent() {
    // Lấy danh sách rạp đã lọc theo movieId và selectedLocation
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
                  onPressed: () {
                    // Có thể thêm logic để thay đổi thành phố nếu cần
                  },
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
                                  itemCount: filteredCinemas.length + 1, // Thêm 1 cho "Tất cả rạp"
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      // Mục "Tất cả rạp"
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
                                      // Các rạp đã lọc
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

  // Helper Widget để tạo các tag thông tin (T16, Thời lượng, Ngày)
  Widget _buildInfoTag(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        // border: Border.all(color: color), // Viền nếu muốn
        color: color.withOpacity(0.15), // Nền mờ
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

  // Widget xây dựng nội dung cho Tab "Thông Tin"
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
            movie.description, // Hiển thị mô tả phim
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          // Thêm thông tin khác nếu có (Đạo diễn, Diễn viên,...)
          _buildInfoRow('Đạo diễn:', '${widget.movie.director}'),
          _buildInfoRow('Diễn viên:', '${widget.movie.casts?.join(", ")}, ...'),
          _buildInfoRow('Thể loại:', 'Hành động, Phiêu lưu'),
          // Lấy từ dữ liệu phim
          _buildInfoRow('Ngày phát hành:', DateFormat('dd/MM/yyyy').format(DateTime.parse(movie.releaseDate))),
          _buildInfoRow('Thời lượng:', '${movie.duration} phút'),
        ],
      ),
    );
  }

  // Helper row for information tab
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110, // Fixed width for label
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
}

// Helper class để tạo SliverPersistentHeader cho TabBar
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
    // Thêm Container để có thể tùy chỉnh màu nền nếu muốn
    return Container(
      color:
          Theme.of(context).scaffoldBackgroundColor, // Màu nền giống Scaffold
      // decoration: BoxDecoration( // Thêm viền dưới nếu muốn
      //    border: Border(bottom: BorderSide(color: Colors.grey[300]!))
      // ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true; // Không cần rebuild vì TabBar không thay đổi
  }
}
