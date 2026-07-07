// lib/screens/news_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/news_model.dart';
import '../repositories/news_repository.dart';
import '../constants/app_colors.dart';
import '../constants/app_font_sizes.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsRepository _newsRepository = NewsRepository();
  late Future<NewsPaginatedResponse> _newsFuture;
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  int _bannerCount = 0;

  @override
  void initState() {
    super.initState();
    _newsFuture = _newsRepository.fetchNews();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.hasClients && _bannerCount > 0) {
        _currentPage++;
        if (_currentPage >= _bannerCount) {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<NewsPaginatedResponse>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.articles.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada berita ditemukan.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final articles = snapshot.data!.articles;
          // Ambil maksimal 3 artikel untuk dijadikan Breaking News / Banner Utama
          final breakingNewsList = articles.take(3).toList();
          _bannerCount = breakingNewsList.length;
          // Sisanya dimasukkan ke list "Artikel Lainnya"
          final otherArticles = articles.skip(_bannerCount).toList();

          return CustomScrollView(
            slivers: [
              // 1. Bagian Judul "Breaking News"
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: Colors.orangeAccent,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Trending Hari Ini',
                        style: TextStyle(
                          fontSize: AppFontSizes.xl,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Widget Banner Utama (Breaking News)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(
                      height: 220,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: breakingNewsList.length,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemBuilder: (context, index) {
                          return _buildBreakingNewsBanner(
                            breakingNewsList[index],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Indikator Titik (Dots)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        breakingNewsList.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.primary
                                : Colors.white24,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Bagian Judul "Artikel Lainnya"
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 32, 16, 12),
                  child: Row(
                    children: [
                      Icon(Icons.article, color: AppColors.primary, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Berita Terkini',
                        style: TextStyle(
                          fontSize: AppFontSizes.xl,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. List Vertikal "Artikel Lainnya" menggunakan SliverList
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = otherArticles[index];
                  return _buildArticleRowItem(item);
                }, childCount: otherArticles.length),
              ),

              // Beri sedikit space di paling bawah tumpukan
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }

  // --- WIDGET KOMPONEN HASIL EXTRACT ---

  Widget _buildBreakingNewsBanner(NewsArticleModel item) {
    final formattedDate = DateFormat('dd MMMM yy').format(item.createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gambar Background
          Image.network(
            'https://picsum.photos/seed/${item.id}/400/300',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.grey),
          ),
          // Gradient Overlay agar teks mudah dibaca
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.0, 0.7],
              ),
            ),
          ),
          // Konten Teks di Atas Gambar
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'TRENDING',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: AppFontSizes.xl,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: AppFontSizes.xs,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleRowItem(NewsArticleModel item) {
    final formattedDate = DateFormat('dd MMMM yy').format(item.createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              'https://picsum.photos/seed/${item.id}/200/200',
              width: 110,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(width: 110, color: Colors.grey),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: AppFontSizes.md,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.excerpt,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: AppFontSizes.xs,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
