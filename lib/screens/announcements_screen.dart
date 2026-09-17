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
              const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white38,
                size: 48,
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
      separatorBuilder: (context, i) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Divider(color: AppColors.cardBorder, height: 1, thickness: 0.5),
      ),
      itemBuilder: (context, index) {
        final item = _announcements[index];
        return _AnnouncementCardItem(
          item: item,
          onOpenActionUrl: _openActionUrl,
          onShowImage: _showImageDialog,
          onCopy: _copyAnnouncement,
        );
      },
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

class _AnnouncementCardItem extends StatefulWidget {
  final AnnouncementModel item;
  final Function(String?) onOpenActionUrl;
  final Function(String) onShowImage;
  final Function(AnnouncementModel) onCopy;

  const _AnnouncementCardItem({
    required this.item,
    required this.onOpenActionUrl,
    required this.onShowImage,
    required this.onCopy,
  });

  @override
  State<_AnnouncementCardItem> createState() => _AnnouncementCardItemState();
}

class _AnnouncementCardItemState extends State<_AnnouncementCardItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
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

          // Image Thumbnail (if available) - Always visible by default
          if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: GestureDetector(
                onTap: () => widget.onShowImage(item.imageUrl!),
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
                    if (item.isPinned)
                      Positioned(
                        left: 10,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.push_pin_rounded,
                            color: Color(0xFFEAB308),
                            size: 16,
                          ),
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
            ),

          const SizedBox(height: 12),

          // Card Content Area
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title, Timestamp, and Dropdown toggle button
              GestureDetector(
                onTap: _toggleExpand,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Timestamp
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: AppFontSizes.lg,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                if (item.isPinned &&
                                    (item.imageUrl == null ||
                                        item.imageUrl!.isEmpty)) ...[
                                  const Icon(
                                    Icons.push_pin_rounded,
                                    color: Color(0xFFEAB308),
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                ],
                                Text(
                                  item.timeAgo ?? item.formattedDate ?? '',
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Tombol Dropdown
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: _isExpanded
                              ? AppColors.primaryLight
                              : Colors.white70,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Expandable Content (Muncul dari atas ke bawah)
              SizeTransition(
                sizeFactor: _expandAnimation,
                axisAlignment: -1.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                    // Action Button (if URL provided)
                    if (item.actionUrl != null &&
                        item.actionUrl!.isNotEmpty) ...[
                      const SizedBox(height: 14),
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
                          onPressed: () =>
                              widget.onOpenActionUrl(item.actionUrl),
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
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
