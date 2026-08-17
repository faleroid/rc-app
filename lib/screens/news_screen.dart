// lib/screens/news_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_model.dart';
import '../repositories/news_repository.dart';
import '../constants/app_colors.dart';
import '../constants/app_font_sizes.dart';
import '../widgets/bitcoin_chart_widget.dart';
import '../utils/date_formatter.dart';

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

  Future<void> _openArticleLink(String linkUrl) async {
    if (linkUrl.isEmpty) return;
    final Uri uri = Uri.parse(linkUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $linkUrl');
    }
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
          final breakingNewsList = articles.take(3).toList();
          _bannerCount = breakingNewsList.length;
          final otherArticles = articles.skip(_bannerCount).toList();

          return CustomScrollView(
            slivers: [
              // 2.5. Bitcoin Chart
              const SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: BitcoinChartWidget(),
                    ),
                  ],
                ),
              ),

              // 1. Bagian Judul "Breaking News"
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Row(
                    children: [
                      Text(
                        'Trending Hari ini',
                        style: TextStyle(
                          fontSize: AppFontSizes.xl,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.local_fire_department, color: Colors.orange),
                    ],
                  ),
                ),
              ),

              // 2. PageView Banner Utama (Breaking News Carousel)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 175,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: breakingNewsList.length,
                    itemBuilder: (context, index) {
                      final item = breakingNewsList[index];
                      return _buildBreakingNewsBanner(item);
                    },
                  ),
                ),
              ),

              // 3. Bagian Judul "Artikel Lainnya"
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Text(
                    'Berita Terkini',
                    style: TextStyle(
                      fontSize: AppFontSizes.xl,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
    final formattedDate = DateFormatter.formatNewsDate(
      timeAgo: item.timeAgo,
      pubDate: item.pubDate,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderColor,
          width: AppColors.borderWidth,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openArticleLink(item.link),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Badge Breaking News
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'BREAKING NEWS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: AppFontSizes.lg,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: AppFontSizes.xs,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: AppFontSizes.xs,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleRowItem(NewsArticleModel item) {
    final formattedDate = DateFormatter.formatNewsDate(
      timeAgo: item.timeAgo,
      pubDate: item.pubDate,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openArticleLink(item.link),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: AppFontSizes.md,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
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
                const SizedBox(height: 12),
                const Divider(height: 12, thickness: 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
