import 'package:flutter/material.dart';
import '../data/booking_data.dart';
import '../data/bookingdetail_data.dart';
import '../models/showtime.dart';
import '../models/room.dart';
import '../models/seat.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Room room;
  final List<Seat> allSeats;
  final Showtime showtime;

  const SeatSelectionScreen({
    super.key,
    required this.room,
    required this.allSeats,
    required this.showtime,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final List<String> _selectedSeats = [];
  Set<int> _bookedSeatIdsForShowtime = {};
  bool _isLoadingBookedSeats = true;

  final Color availableColor = Colors.grey[200]!;
  final Color bookedColor = Colors.grey[500]!;
  final Color selectedColor = Colors.orange;
  final Color seatBorderColor = Colors.grey[400]!;

  final double _labelWidth = 20.0;
  final double _labelSeatSpacing = 5.0;
  final double _seatPadding = 2.0;

  @override
  void initState() {
    super.initState();
    _loadBookedSeats();
  }

  // Tải danh sách ghế đã đặt cho suất chiếu hiện tại
  void _loadBookedSeats() {
    setState(() {
      _isLoadingBookedSeats = true;
    });

    // Lấy danh sách booking cho suất chiếu hiện tại
    final bookingsForShowtime =
        sampleBookings
            .where((booking) => booking.showtimeId == widget.showtime.id)
            .toList();

    // Lấy danh sách seatId đã đặt từ booking details
    final bookedSeatIds = <int>{};
    for (var booking in bookingsForShowtime) {
      final details =
          sampleBookingDetails
              .where((detail) => detail.bookingId == booking.id)
              .toList();
      bookedSeatIds.addAll(details.map((detail) => detail.seatId));
    }

    setState(() {
      _bookedSeatIdsForShowtime = bookedSeatIds;
      _isLoadingBookedSeats = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final rowLabels = List.generate(
      widget.room.seatColumnMax,
      (i) => String.fromCharCode(65 + i),
    );
    final columnCount = widget.room.seatRowMax;

    return Scaffold(
      appBar: AppBar(
        title: Text("Chọn Ghế - ${widget.room.name}"),
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body:
          _isLoadingBookedSeats
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
                              "Một Bộ Phim Minecraft", // Có thể lấy từ showtime
                              style: TextStyle(
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
                        Text(
                          "${widget.showtime.startTime.hour}:${widget.showtime.startTime.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
                              children:
                                  rowLabels.reversed.map((row) {
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
                                                    (availableWidth /
                                                        columnCount) -
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: List.generate(
                                                    columnCount,
                                                    (index) {
                                                      final seatNumber =
                                                          '$row${index + 1}';
                                                      final seat = widget
                                                          .allSeats
                                                          .firstWhere(
                                                            (s) =>
                                                                s.seatNumber ==
                                                                seatNumber,
                                                            orElse: () {
                                                              print(
                                                                'Error: Seat $seatNumber not found',
                                                              );
                                                              return Seat(
                                                                id: -1,
                                                                roomId:
                                                                    widget
                                                                        .room
                                                                        .id,
                                                                seatNumber:
                                                                    seatNumber,
                                                              );
                                                            },
                                                          );
                                                      // Kiểm tra ghế đã đặt dựa trên seatId
                                                      final isBooked =
                                                          _bookedSeatIdsForShowtime
                                                              .contains(
                                                                seat.id,
                                                              );
                                                      final isSelected =
                                                          _selectedSeats
                                                              .contains(
                                                                seatNumber,
                                                              );

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
                            onPressed:
                                _selectedSeats.isEmpty
                                    ? null
                                    : () {
                                      // Xử lý khi nhấn nút Tiếp tục
                                      print('Ghế đã chọn: $_selectedSeats');
                                      // Điều hướng hoặc lưu booking...
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
        onTap:
            isBooked
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
