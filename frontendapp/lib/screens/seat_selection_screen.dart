import 'package:flutter/material.dart';
import 'package:frontendapp/models/showtime.dart';

import '../models/room.dart';
import '../models/seat.dart'; // Giả sử bạn có model này

class SeatSelectionScreen extends StatefulWidget {
  final Room room;
  final List<Seat> allSeats; // Danh sách tất cả ghế, bao gồm cả trạng thái isBooked
  final Showtime showtime; // Có thể cần cho thông tin phim, giờ chiếu...

  const SeatSelectionScreen({
    super.key,
    required this.room,
    required this.allSeats,
    required this.showtime, // Đảm bảo bạn truyền đối tượng này vào
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final List<String> _selectedSeats = []; // Lưu danh sách seatNumber đang được chọn
  Set<int> _bookedSeatIdsForShowtime = {}; // Set để lưu ID ghế đã đặt cho suất chiếu này
  bool _isLoadingBookedSeats = true; // Cờ để biết đang tải dữ liệu

  // --- Định nghĩa màu sắc ---
  final Color availableColor = Colors.grey[200]!; // Màu ghế trống
  final Color bookedColor = Colors.grey[500]!;    // Màu ghế đã bán
  final Color selectedColor = Colors.orange;      // Màu ghế đang chọn
  final Color seatBorderColor = Colors.grey[400]!; // Màu viền ghế trống

  final double _labelWidth = 20.0;
  final double _labelSeatSpacing = 5.0;
  final double _seatPadding = 2.0;

  @override
  Widget build(BuildContext context) {
    // Đảo ngược lại: rowLabels giờ là A, B, C... và columnCount là số ghế trên mỗi hàng
    final rowLabels = List.generate(widget.room.seatColumnMax, (i) => String.fromCharCode(65 + i)); // ['A', 'B', 'C', ...]
    final columnCount = widget.room.seatRowMax; // Số ghế trên một hàng, ví dụ: 10

    return Scaffold(
      // --- AppBar ---
      appBar: AppBar(
        title: Text("Chọn Ghế - ${widget.room.name}"),
        // Thêm các thông tin khác nếu cần, ví dụ tên phim từ widget.showtime
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white, // Nền trắng cho toàn màn hình
      body: Column(
        children: [
          // --- Thông tin phim/suất chiếu (Tùy chọn) ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Ví dụ hiển thị tên phim và định dạng
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thay thế bằng thông tin thực tế từ widget.showtime
                    Text("Một Bộ Phim Minecraft", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("2D LỒNG TIẾNG", style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                // Ví dụ hiển thị giờ chiếu
                Text("18:15", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[300]),

          // --- Khu vực chọn ghế ---
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding cho toàn bộ lưới ghế
                child: Column(
                  children: [
                    // --- Lưới ghế ---
                    Column(
                      children: rowLabels.reversed.map((row) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0), // Giảm khoảng cách dọc giữa các hàng
                          child: Row(
                            children: [
                              // --- Nhãn hàng (A, B, C...) ---
                              SizedBox(
                                width: _labelWidth,
                                child: Text(
                                  row,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                              ),
                              SizedBox(width: _labelSeatSpacing),

                              // --- Hàng ghế (Sử dụng LayoutBuilder) ---
                              Expanded(
                                child: LayoutBuilder( // **THÊM LAYOUTBUILDER**
                                  builder: (context, constraints) {
                                    // constraints.maxWidth là chiều rộng tối đa mà Expanded cung cấp
                                    final availableWidth = constraints.maxWidth;

                                    // Tính kích thước tối đa cho mỗi ghế (bao gồm cả padding của nó)
                                    // Tổng padding ngang cho 1 ghế là _seatPadding * 2
                                    double seatSize = (availableWidth / columnCount) - (_seatPadding * 2);

                                    // Đảm bảo kích thước không âm và giới hạn kích thước tối đa nếu muốn
                                    seatSize = seatSize.clamp(0, 35.0); // Giới hạn kích thước từ 0 đến 35

                                    // Nếu tính toán ra kích thước không hợp lệ (quá nhỏ)
                                    if (seatSize <= 0) {
                                      // Có thể hiển thị lỗi hoặc trả về container trống
                                      return Container(
                                          alignment: Alignment.center,
                                          child: Text('!', style: TextStyle(color: Colors.red, fontSize: 10))
                                      );
                                    }

                                    // Xây dựng Row chứa các ghế với kích thước đã tính
                                    return Row(
                                      // Căn chỉnh các ghế trong không gian có sẵn
                                      // MainAxisAlignment.spaceAround hoặc spaceEvenly có thể đẹp hơn center
                                      // khi kích thước ghế nhỏ hơn không gian được chia.
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: List.generate(columnCount, (index) {
                                        final seatNumber = '$row${index + 1}';
                                        final seat = widget.allSeats.firstWhere(
                                              (s) => s.seatNumber == seatNumber,
                                          orElse: () => Seat(id: -1, roomId: widget.room.id, seatNumber: seatNumber, isBooked: false),
                                        );
                                        final isBooked = seat.isBooked;
                                        final isSelected = _selectedSeats.contains(seatNumber);

                                        // **TRUYỀN KÍCH THƯỚC VÀ PADDING VÀO HÀM BUILD**
                                        return _buildSeatItem(
                                            seatNumber, isBooked, isSelected, seatSize, _seatPadding);
                                      }),
                                    );
                                  },
                                ),
                              ),

                              // Không cần Spacer cân bằng nữa vì LayoutBuilder đã xử lý không gian
                              // SizedBox(width: _labelWidth + _labelSeatSpacing),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    // --- Chỉ báo Màn hình ---
                    Text(
                      "MÀN HÌNH",
                      style: TextStyle(color: Colors.grey[700], fontSize: 12, letterSpacing: 2),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 40), // Tạo khoảng trống 2 bên
                      decoration: BoxDecoration(
                          color: Colors.orange[700],
                          borderRadius: BorderRadius.circular(2)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- Phần Chú thích và Nút Tiếp tục ---
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[100], // Màu nền cho phần chú thích
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, -2), // Shadow phía trên
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Chỉ chiếm không gian cần thiết
              children: [
                // --- Chú thích (Legend) ---
                _buildLegend(),
                const SizedBox(height: 16),

                // --- Nút Tiếp tục ---
                SizedBox(
                  width: double.infinity, // Nút rộng hết cỡ
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Màu nền nút
                      foregroundColor: Colors.white, // Màu chữ
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _selectedSeats.isEmpty
                        ? null // Vô hiệu hóa nếu chưa chọn ghế
                        : () {
                      // Xử lý khi nhấn nút Tiếp tục
                      print('Ghế đã chọn: $_selectedSeats');
                      // Điều hướng sang màn hình tiếp theo hoặc xử lý logic booking...
                    },
                    child: Text(
                      _selectedSeats.isEmpty
                          ? "Tiếp tục"
                          : "Tiếp tục (${_selectedSeats.length} ghế)",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  // --- Widget xây dựng một ô ghế (CẬP NHẬT ĐỂ HIỂN THỊ SỐ GHẾ KHI CHỌN) ---
  Widget _buildSeatItem(String seatNumber, bool isBooked, bool isSelected, double seatSize, double seatPadding) {
    Color color = availableColor;
    Border? border = Border.all(color: seatBorderColor, width: 0.5);
    Color textColor = Colors.transparent; // Mặc định không hiển thị text

    if (isBooked) {
      color = bookedColor;
      border = null;
    } else if (isSelected) {
      color = selectedColor;
      border = null;
      textColor = Colors.white; // **HIỂN THỊ TEXT MÀU TRẮNG KHI ĐƯỢC CHỌN**
    }

    final double borderRadius = seatSize * 0.15;
    // Tính toán cỡ chữ phù hợp với kích thước ghế, ví dụ 35-40% kích thước ghế
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
          // **THÊM CHILD LÀ TEXT WIDGET**
          child: Center( // Dùng Center để căn chữ vào giữa ô ghế
            child: Text(
              seatNumber,
              style: TextStyle(
                color: textColor, // Màu chữ thay đổi dựa trên trạng thái isSelected
                fontSize: fontSize, // Cỡ chữ động
                fontWeight: FontWeight.w500, // Độ đậm vừa phải
              ),
              textAlign: TextAlign.center,
              // Xử lý nếu chữ quá dài (dù ít khả năng với số ghế)
              overflow: TextOverflow.clip,
              softWrap: false,
            ),
          ),
        ),
      ),
    );
  }


  // --- Widget xây dựng phần chú thích ---
  Widget _buildLegend() {
    return Wrap( // Dùng Wrap để tự động xuống hàng nếu không đủ chỗ
      spacing: 16.0, // Khoảng cách ngang giữa các mục
      runSpacing: 8.0, // Khoảng cách dọc giữa các hàng (nếu có)
      alignment: WrapAlignment.center,
      children: [
        _buildLegendItem(availableColor, 'Ghế trống', border: Border.all(color: seatBorderColor)),
        _buildLegendItem(selectedColor, 'Đang chọn'),
        _buildLegendItem(bookedColor, 'Đã bán'),
        // Thêm các loại ghế khác nếu cần (VIP, đôi...)
        // _buildLegendItem(Colors.blue, 'Ghế VIP'),
        // _buildLegendItem(Colors.purple, 'Ghế đôi'),
      ],
    );
  }

  // --- Widget xây dựng một mục trong chú thích ---
  Widget _buildLegendItem(Color color, String text, {Border? border}) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Chỉ chiếm chiều rộng cần thiết
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