import 'package:flutter/material.dart';
import 'package:frontendapp/models/user.dart';
import 'package:frontendapp/services/BookingService.dart';
import 'package:frontendapp/config.dart';
import 'package:intl/intl.dart';

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
  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  final double maxSpendingForProgressBar = 4000000;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final user = Config.currentUser;
      if (user == null) {
        throw Exception('Không tìm thấy thông tin người dùng. Vui lòng đăng nhập lại.');
      }
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
      Config.isLogin = false;
      Config.currentUser = null;
      if (mounted) {
        // Điều hướng về DefaultScreen và chọn tab "Trang chủ" (index 0)
        Navigator.pushNamedAndRemoveUntil(context, '/default', (route) => false, arguments: 0);
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
        title: const Text('Tài khoản', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      )
          : RefreshIndicator(
        onRefresh: _fetchUser,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _buildUserInfoSection()),
              const Divider(height: 10, thickness: 1),
              _buildTabs(),
              const Divider(height: 10, thickness: 1),
              _buildSelectedTabContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: Icon(
              Icons.person,
              size: 30,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _user?.name ?? 'Unknown User',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTab(Icons.person_outline, 'Thông tin', 0),
          _buildTab(Icons.receipt_long_outlined, 'Giao dịch', 1),
          _buildTab(Icons.notifications_none_outlined, 'Thông báo', 2),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String title, int index) {
    bool isSelected = _selectedTab == index;
    Color color = isSelected ? Colors.orange[700]! : Colors.grey[600]!;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 2.5,
            width: 60,
            color: isSelected ? Colors.orange[700] : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildInfoTabContent();
      case 1:
        return _buildTransactionsTabContent();
      case 2:
        return _buildNotificationsTabContent();
      default:
        return Container();
    }
  }

  Widget _buildInfoTabContent() {
    int currentYear = DateTime.now().year;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Tổng chi tiêu $currentYear',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.info_outline, color: Colors.blue[600], size: 18),
                ],
              ),
              Text(
                currencyFormatter.format(_totalSpending ?? 0),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          _buildProgressBar(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOptionButton(
                icon: Icons.star_border,
                label: 'Đổi Quà',
              ),
              _buildOptionButton(
                icon: Icons.card_giftcard,
                label: 'My Rewards',
              ),
              _buildOptionButton(
                icon: Icons.diamond_outlined,
                label: 'Gói Hội Viên',
              ),
            ],
          ),
          const SizedBox(height: 25),
          _buildListTile(
            title: 'Gọi ĐƯỜNG DÂY NÓNG: 19002224',
            icon: Icons.phone_outlined,
            onTap: () {},
          ),
          _buildListTile(
            title: 'Email: ${_user?.email ?? 'N/A'}',
            icon: Icons.email_outlined,
            onTap: () {},
          ),
          _buildListTile(
            title: 'Thông Tin Công Ty',
            icon: Icons.business_center_outlined,
            onTap: () {},
          ),
          _buildListTile(
            title: 'Điều Khoản Sử Dụng',
            icon: Icons.description_outlined,
            onTap: () {},
          ),
          _buildListTile(
            title: 'Chính Sách Thanh Toán',
            icon: Icons.description_outlined,
            onTap: () {},
          ),
          _buildListTile(
            title: 'Chính Sách Bảo Mật',
            icon: Icons.description_outlined,
            onTap: () {},
          ),
          _buildListTile(
            title: 'FAQ',
            icon: Icons.whatshot_outlined,
            onTap: () {},
          ),
          const SizedBox(height: 25),
          Center(
            child: OutlinedButton(
              onPressed: _logout,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange[700],
                side: BorderSide(color: Colors.orange[700]!),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Đăng xuất',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTransactionsTabContent() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          'Chưa có giao dịch nào.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildNotificationsTabContent() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          'Chưa có thông báo nào.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    double progress = 0.0;
    if (_totalSpending != null && _totalSpending! > 0) {
      progress = (_totalSpending! / maxSpendingForProgressBar).clamp(0.0, 1.0);
    }
    double screenWidth = MediaQuery.of(context).size.width - 32;

    return SizedBox(
      height: 100,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 8,
            width: screenWidth,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Container(
            height: 8,
            width: screenWidth * progress,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[300]!, Colors.blue[600]!],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          _buildProgressMarker(0.0, screenWidth, isActive: true),
          _buildProgressMarker(0.5, screenWidth, isActive: progress >= 0.5),
          _buildProgressMarker(1.0, screenWidth, isActive: progress >= 1.0),
          Positioned(
            left: 0,
            top: 15,
            child: const Text('0đ', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
          Positioned(
            left: screenWidth * 0.5 - 35,
            top: 15,
            child: const Text('2,000,000đ', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
          Positioned(
            right: 0,
            top: 15,
            child: const Text('4,000,000đ', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressMarker(double positionPercent, double totalWidth, {required bool isActive}) {
    return Positioned(
      left: totalWidth * positionPercent - 6,
      top: -5,
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? Colors.blue[600]! : Colors.grey[300]!,
            width: 2.5,
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton({required IconData icon, required String label}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue[50],
          child: Icon(icon, size: 28, color: Colors.blue[700]),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildListTile({required String title, IconData? icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.grey[600], size: 22),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}