import 'package:flutter/material.dart';
import 'package:frontendapp/models/user.dart';
import 'package:frontendapp/services/BookingService.dart';
import 'package:frontendapp/config.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  User? _user;
  int? _totalSpending;
  bool _isLoading = true;
  String? _errorMessage;
  int _selectedTab = 0;

  final BookingService _bookingService = BookingService();

  @override
  void initState() {
    super.initState();
    _fetchUser(); // Gọi trực tiếp _fetchUser mà không cần kiểm tra đăng nhập
  }

  Future<void> _fetchUser() async {
    try {
      // Lấy thông tin người dùng từ Config
      final user = Config.currentUser;

      if (user == null) {
        throw Exception('Không tìm thấy thông tin người dùng. Vui lòng đăng nhập lại.');
      }

      // Lấy tổng chi tiêu từ BookingService
      final totalSpending = await _bookingService.sumTotalPriceByUserId(user.id ?? 0);

      if (mounted) {
        setState(() {
          _user = user;
          _totalSpending = totalSpending;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    try {
      // Đặt lại trạng thái đăng nhập và thông tin người dùng
      Config.isLogin = false;
      Config.currentUser = null;

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dangnhap');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi đăng xuất: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tài khoản'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              _user!.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Star',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 16,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.card_giftcard,
                              color: Colors.orange,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '0 Stars',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Mã thành viên',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTab('Thông tin', 0),
                  _buildTab('Giao dịch', 1),
                  _buildTab('Thông báo', 2),
                ],
              ),
            ),
            const Divider(),
            if (_selectedTab == 0) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tổng chi tiêu 2025',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(Icons.info_outline, color: Colors.blue),
                        Text(
                          '${_totalSpending ?? 0}đ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildProgressBar(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildOptionButton(
                          icon: 'assets/icons/gift_icon.png',
                          label: 'Đổi Quà',
                        ),
                        _buildOptionButton(
                          icon: 'assets/icons/rewards_icon.png',
                          label: 'My Rewards',
                        ),
                        _buildOptionButton(
                          icon: 'assets/icons/membership_icon.png',
                          label: 'Gói Hội Viên',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildListTile(
                      title: 'Gói DUỔNG DẪY NỘNG: 19002224',
                      onTap: () {},
                    ),
                    _buildListTile(
                      title: 'Email: ${_user!.email}',
                      onTap: () {},
                    ),
                    _buildListTile(
                      title: 'Thông Tin Công Ty',
                      onTap: () {},
                    ),
                    _buildListTile(
                      title: 'Điều Khoản Sử Dụng',
                      onTap: () {},
                    ),
                    _buildListTile(
                      title: 'Chính Sách Thanh Toán',
                      onTap: () {},
                    ),
                    _buildListTile(
                      title: 'Chính Sách Bảo Mật',
                      onTap: () {},
                    ),
                    _buildListTile(
                      title: 'FAQ',
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: _logout,
                        child: const Text(
                          'Đăng xuất',
                          style: TextStyle(
                            color: Colors.orange,
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
            if (_selectedTab == 1)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Chưa có giao dịch nào.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            if (_selectedTab == 2)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Chưa có thông báo nào.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            // Rạp phim
          } else if (index == 2) {
            // Sản phẩm
          } else if (index == 3) {
            // Diễn ảnh
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Rạp phim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Sản phẩm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Diễn ảnh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: _selectedTab == index ? FontWeight.bold : FontWeight.normal,
              color: _selectedTab == index ? Colors.blue : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          if (_selectedTab == index)
            Container(
              height: 2,
              width: 40,
              color: Colors.blue,
            ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Stack(
      children: [
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Container(
          height: 10,
          width: MediaQuery.of(context).size.width * 0.8 * (_totalSpending != null ? _totalSpending! / 4000000 : 0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Positioned(
          left: 0,
          top: -10,
          child: const Icon(Icons.star, color: Colors.orange, size: 16),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width * 0.8 * 0.5 - 8,
          top: -10,
          child: const Icon(Icons.star, color: Colors.blue, size: 16),
        ),
        Positioned(
          right: 0,
          top: -10,
          child: const Icon(Icons.star, color: Colors.red, size: 16),
        ),
        Positioned(
          left: 0,
          bottom: -20,
          child: const Text('0đ', style: TextStyle(fontSize: 12)),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width * 0.8 * 0.5 - 30,
          bottom: -20,
          child: const Text('2,000,000đ', style: TextStyle(fontSize: 12)),
        ),
        Positioned(
          right: 0,
          bottom: -20,
          child: const Text('4,000,000đ', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildOptionButton({required String icon, required String label}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue[50],
          child: Image.asset(icon, width: 40, height: 40),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildListTile({required String title, required VoidCallback onTap}) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}