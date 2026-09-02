import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_font_sizes.dart';
import '../models/announcement_model.dart';
import '../repositories/announcement_repository.dart';
import '../services/announcement_tracker_service.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final AnnouncementRepository _repository = AnnouncementRepository();
  final TextEditingController _searchController = TextEditingController();

  List<AnnouncementModel> _announcements = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedCategory = 'all';
  String _searchQuery = '';

  final List<Map<String, String>> _categories = [
    {'key': 'all', 'label': 'Semua'},
    {'key': 'event', 'label': 'Event'},
    {'key': 'info', 'label': 'Info'},
    {'key': 'urgent', 'label': 'Penting'},
    {'key': 'general', 'label': 'Umum'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchData({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _repository.fetchAnnouncements(
        category: _selectedCategory,
        search: _searchQuery,
        forceRefresh: forceRefresh,
      );

      if (mounted) {
        setState(() {
          _announcements = response.announcements;
          _isLoading = false;
        });

        // Tandai semua pengumuman sebagai sudah dibaca
        AnnouncementTrackerService().markAllAsRead(response.announcements);
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

  Future<void> _openActionUrl(String? url) async {
    if (url == null || url.trim().isEmpty) return;
    final uri = Uri.parse(url.trim());
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka tautan.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error membuka tautan: $e')));
      }
    }
  }

  void _copyAnnouncement(AnnouncementModel item) {
    final text =
        '${item.title}\n\n${item.content}${item.actionUrl != null ? '\n\nTautan: ${item.actionUrl}' : ''}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Pengumuman berhasil disalin.'),
          ],
        ),
        backgroundColor: AppColors.cardDark,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.cardBorder, width: 0.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text(
          'Pengumuman',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppFontSizes.lg,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter Header
          _buildFilterSection(),

          // Main Announcement List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchData,
              color: AppColors.primary,
              backgroundColor: AppColors.cardDark,
              child: _buildBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.cardBorder, width: 0.5),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                color: Colors.white,
                fontSize: AppFontSizes.sm,
              ),
              decoration: InputDecoration(
                hintText: 'Cari pengumuman...',
                hintStyle: const TextStyle(
                  color: Colors.white38,
                  fontSize: AppFontSizes.sm,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.white54,
                  size: 20,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear_rounded,
                          color: Colors.white54,
                          size: 18,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                          _fetchData();
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _fetchData();
              },
            ),
          ),
          const SizedBox(height: 12),

          // Categories Chips
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, i) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat['key'];

                return GestureDetector(
                  onTap: () {
                    if (_selectedCategory != cat['key']) {
                      setState(() {
                        _selectedCategory = cat['key']!;
                      });
                      _fetchData();
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.cardDark,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.cardBorder,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        cat['label']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: AppFontSizes.xs,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.webRed,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: AppFontSizes.sm,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _fetchData,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_announcements.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white38,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ups, belum ada pengumuman nih',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppFontSizes.md,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Nantikan info selanjutnya yaaa, stay tune!',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: AppFontSizes.xs,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _announcements.length,
      separatorBuilder: (context, i) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = _announcements[index];
        return _buildAnnouncementCard(item);
      },
    );
  }

  Widget _buildAnnouncementCard(AnnouncementModel item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isPinned
              ? const Color(0xFFEAB308).withValues(alpha: 0.6)
              : AppColors.cardBorder,
          width: item.isPinned ? 1.5 : 1.0,
        ),
        boxShadow: item.isPinned
            ? [
                BoxShadow(
                  color: const Color(0xFFEAB308).withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pinned Banner Bar
            if (item.isPinned)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFEAB308).withValues(alpha: 0.25),
                      const Color(0xFFCA8A04).withValues(alpha: 0.10),
                    ],
                  ),
                ),
              ),

            // Image Thumbnail (if available)
            if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
              GestureDetector(
                onTap: () => _showImageDialog(item.imageUrl!),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 180,
                      color: Colors.black26,
                      child: Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.fullscreen_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Card Content Area
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge & Date Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCategoryBadge(item.category),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            color: Colors.white38,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.timeAgo ?? item.formattedDate ?? '',
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppFontSizes.lg,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Content Body
                  Text(
                    item.content,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: AppFontSizes.sm,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Action Button (if URL provided)
                  if (item.actionUrl != null && item.actionUrl!.isNotEmpty) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _openActionUrl(item.actionUrl),
                        icon: const Icon(Icons.open_in_new_rounded, size: 16),
                        label: Text(
                          item.actionLabel?.isNotEmpty == true
                              ? item.actionLabel!
                              : 'Buka Tautan / Detail',
                          style: const TextStyle(
                            fontSize: AppFontSizes.sm,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  const Divider(color: Colors.white12, height: 1),
                  const SizedBox(height: 10),

                  // Footer: Author & Share
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Author
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 11,
                            backgroundColor: AppColors.primary,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item.author?.name ?? 'RicoCapital',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),

                      // Share / Copy Button
                      IconButton(
                        icon: const Icon(
                          Icons.share_outlined,
                          color: Colors.white70,
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Salin Pengumuman',
                        onPressed: () => _copyAnnouncement(item),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    Color bg;
    Color border;
    Color text;
    String label;
    IconData icon;

    switch (category.toLowerCase()) {
      case 'event':
        bg = const Color(0xFF451A03);
        border = const Color(0xFFB45309);
        text = const Color(0xFFFCD34D);
        label = 'Event';
        icon = Icons.calendar_today_rounded;
        break;
      case 'urgent':
        bg = const Color(0xFF4C0519);
        border = const Color(0xFFBE123C);
        text = const Color(0xFFFDA4AF);
        label = 'Penting';
        icon = Icons.warning_amber_rounded;
        break;
      case 'info':
        bg = const Color(0xFF083344);
        border = const Color(0xFF0E7490);
        text = const Color(0xFF67E8F9);
        label = 'Info';
        icon = Icons.info_outline_rounded;
        break;
      case 'general':
      default:
        bg = const Color(0xFF3B0764);
        border = const Color(0xFF7E22CE);
        text = const Color(0xFFD8B4FE);
        label = 'Umum';
        icon = Icons.notifications_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: text, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: text,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(12),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
