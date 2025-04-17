import 'package:flutter/material.dart';
import 'package:frontendapp/screens/payment_screen.dart';
import '../models/cinema.dart';
import '../models/movie.dart';
import '../models/showtime.dart';
import '../models/room.dart';
import '../models/seat.dart';
import '../services/BookingService.dart';
import '../services/RoomService.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Room room;
  final List<Seat> allSeats;
  final Showtime showtime;
  final Movie movie;
  final Cinema cinema;
  final List<Showtime> listshowtime;

  const SeatSelectionScreen({
    super.key,
    required this.room,
    required this.allSeats,
    required this.showtime,
    required this.movie,
    required this.cinema,
    required this.listshowtime,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final List<String> _selectedSeats = [];
  Set<int> _bookedSeatIdsForShowtime = {};
  bool _isLoadingBookedSeats = true;
  late Showtime _selectedShowtime;
  late Room _selectedRoom; // Thêm trạng thái cho phòng
  late List<Seat> _allSeats; // Thêm trạng thái cho danh sách ghế

  final Color availableColor = Colors.grey[200]!;
  final Color bookedColor = Colors.grey[500]!;
  final Color selectedColor = Colors.orange;
  final Color seatBorderColor = Colors.grey[400]!;

  final double _labelWidth = 20.0;
  final double _labelSeatSpacing = 5.0;
  final double _seatPadding = 2.0;

  Future<void> _loadBookedSeats() async {
    setState(() {
      _isLoadingBookedSeats = true;
    });

    try {
      BookingService bookingService = BookingService();
      // Lấy danh sách booking cho suất chiếu hiện tại
      final bookingsForShowtime = await bookingService.getBookingsByShowtimeId(_selectedShowtime.id);

      // Lấy danh sách seatId đã đặt từ booking details
      final bookedSeatIds = <int>{};
      for (var booking in bookingsForShowtime) {
        final details = await bookingService.getBookingDetailsByBookingId(booking.id);
        bookedSeatIds.addAll(details.map((detail) => detail.seatId));
      }

      setState(() {
        _bookedSeatIdsForShowtime = bookedSeatIds;
        _isLoadingBookedSeats = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingBookedSeats = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải ghế đã đặt: $e')),
      );
    }
  }

  Future<void> _updateRoomAndSeats(int roomId) async {
    try {
      RoomService roomService = RoomService();
      // Lấy thông tin phòng mới
      final room = await roomService.getRoomById(roomId);
      // Lấy danh sách ghế mới
      final seats = await roomService.getSeatsByRoomId(roomId);

      setState(() {
        _selectedRoom = room;
        _allSeats = seats;
        _selectedSeats.clear();
        _loadBookedSeats();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật phòng và ghế: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedShowtime = widget.showtime;
    _selectedRoom = widget.room; // Khởi tạo phòng ban đầu
    _allSeats = widget.allSeats; // Khởi tạo danh sách ghế ban đầu
    _loadBookedSeats();
  }

  @override
  Widget build(BuildContext context) {
    final rowLabels = List.generate(
      _selectedRoom.seatColumnMax, // Sử dụng _selectedRoom
          (i) => String.fromCharCode(65 + i),
    );
    final columnCount = _selectedRoom.seatRowMax; // Sử dụng _selectedRoom

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.cinema.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: _isLoadingBookedSeats
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "2D LỒNG TIẾNG",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                // DropdownButton để chọn suất chiếu
                DropdownButton<Showtime>(
                  value: _selectedShowtime,
                  onChanged: (Showtime? newShowtime)async {
                    if (newShowtime != null) {
                      setState(() {
                        _selectedShowtime = newShowtime;
                      });
                      await _updateRoomAndSeats(newShowtime.roomId);
                    }
                  },
                  items: widget.listshowtime.map((Showtime showtime) {
                    return DropdownMenuItem<Showtime>(
                      value: showtime,
                      child: Text(
                        "${showtime.startTime.hour}:${showtime.startTime.minute.toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                  icon: const Icon(Icons.arrow_drop_down),
                  underline: Container(),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[300]),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    Column(
                      children: rowLabels.reversed.map((row) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 1.0,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: _labelWidth,
                                child: Text(
                                  row,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              SizedBox(width: _labelSeatSpacing),
                              Expanded(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final availableWidth =
                                        constraints.maxWidth;
                                    double seatSize =
                                        (availableWidth / columnCount) -
                                            (_seatPadding * 2);
                                    seatSize = seatSize.clamp(
                                      0,
                                      35.0,
                                    );

                                    if (seatSize <= 0) {
                                      return Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '!',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 10,
                                          ),
                                        ),
                                      );
                                    }

                                    return Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: List.generate(
                                        columnCount,
                                            (index) {
                                          final seatNumber =
                                              '$row${index + 1}';
                                          final seat = _allSeats.firstWhere(
                                                (s) =>
                                            s.seatNumber ==
                                                seatNumber,
                                            orElse: () {
                                              return Seat(
                                                id: -1,
                                                roomId: _selectedRoom.id,
                                                seatNumber: seatNumber,
                                              );
                                            },
                                          );
                                          // Kiểm tra ghế đã đặt dựa trên seatId
                                          final isBooked =
                                          _bookedSeatIdsForShowtime
                                              .contains(seat.id);
                                          final isSelected =
                                          _selectedSeats.contains(
                                              seatNumber);

                                          return _buildSeatItem(
                                            seatNumber,
                                            isBooked,
                                            isSelected,
                                            seatSize,
                                            _seatPadding,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "MÀN HÌNH",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 40,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[700],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLegend(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _selectedSeats.isEmpty
                        ? null
                        : () {
                      // Tính tổng tiền (giả sử giá vé lấy từ showtime.price)
                      final totalPrice = _selectedShowtime.price *
                          _selectedSeats.length;

                      // Điều hướng đến PaymentScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            movie: widget.movie,
                            cinema: widget.cinema,
                            room: _selectedRoom, // Sử dụng _selectedRoom
                            showTime: _selectedShowtime.startTime,
                            selectedSeats: _selectedSeats,
                            totalPrice: totalPrice,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      _selectedSeats.isEmpty
                          ? "Tiếp tục"
                          : "Tiếp tục (${_selectedSeats.length} ghế)",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatItem(
      String seatNumber,
      bool isBooked,
      bool isSelected,
      double seatSize,
      double seatPadding,
      ) {
    Color color = availableColor;
    Border? border = Border.all(color: seatBorderColor, width: 0.5);
    Color textColor = Colors.transparent;

    if (isBooked) {
      color = bookedColor;
      border = null;
    } else if (isSelected) {
      color = selectedColor;
      border = null;
      textColor = Colors.white;
    }

    final double borderRadius = seatSize * 0.15;
    final double fontSize = seatSize * 0.38;

    return Padding(
      padding: EdgeInsets.all(seatPadding),
      child: GestureDetector(
        onTap: isBooked
            ? null
            : () {
          setState(() {
            if (isSelected) {
              _selectedSeats.remove(seatNumber);
            } else {
              _selectedSeats.add(seatNumber);
            }
          });
        },
        child: Container(
          width: seatSize,
          height: seatSize,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
            border: border,
          ),
          child: Center(
            child: Text(
              seatNumber,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              softWrap: false,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      children: [
        _buildLegendItem(
          availableColor,
          'Ghế trống',
          border: Border.all(color: seatBorderColor),
        ),
        _buildLegendItem(selectedColor, 'Đang chọn'),
        _buildLegendItem(bookedColor, 'Đã bán'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text, {Border? border}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: border,
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}