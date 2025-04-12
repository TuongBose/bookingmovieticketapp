import 'package:flutter/material.dart';
import '../models/movie_news.dart';
import '../services/movie_news_service.dart';

class MovieNewsScreen extends StatefulWidget {
  const MovieNewsScreen({Key? key}) : super(key: key);

  @override
  State<MovieNewsScreen> createState() => _MovieNewsScreenState();
}

class _MovieNewsScreenState extends State<MovieNewsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MovieNewsService _newsService = MovieNewsService();
  List<MovieNews> movieNewsList = [];
  List<Map<String, dynamic>> celebrities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final news = await _newsService.getMovieNews();
      final celebs = await _newsService.getCelebrities();

      setState(() {
        movieNewsList = news;
        celebrities = celebs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải dữ liệu: $e')),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Điện Ảnh',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {

            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Bình luận'),
            Tab(text: 'Tin tức'),
            Tab(text: 'Nhân vật'),
          ],
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          // Tab Bình luận
          _buildNewsListView(),

          // Tab Tin tức
          _buildNewsListView(filterType: 'news'),

          // Tab Nhân vật
          _buildCelebritiesView(),
        ],
      ),

    );
  }

  Widget _buildNewsListView({String? filterType}) {
    List<MovieNews> filteredList = filterType != null
        ? movieNewsList.where((news) => news.type == filterType).toList()
        : movieNewsList;

    if (filteredList.isEmpty) {
      return const Center(child: Text('Không có dữ liệu'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final news = filteredList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh bài viết
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  news.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),

              // Tiêu đề
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  news.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Nút "Đọc thêm"
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                child: TextButton(
                  onPressed: () {

                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Đọc thêm',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCelebritiesView() {
    if (celebrities.isEmpty) {
      return const Center(child: Text('Không có dữ liệu'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: celebrities.length,
      itemBuilder: (context, index) {
        final celebrity = celebrities[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh người nổi tiếng
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Image.network(
                    celebrity['image_url'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.person, size: 40, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Thông tin người nổi tiếng
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        celebrity['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        celebrity['description'],
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Đọc thêm',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}