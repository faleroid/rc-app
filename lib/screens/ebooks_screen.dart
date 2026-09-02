import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_font_sizes.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../models/ebook_model.dart';
import '../repositories/ebook_repository.dart';

class EbooksScreen extends StatefulWidget {
  const EbooksScreen({super.key});

  @override
  State<EbooksScreen> createState() => _EbooksScreenState();
}

class _EbooksScreenState extends State<EbooksScreen> {
  final EbookRepository _repository = EbookRepository();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;
  EbookListResponse? _ebookResponse;

  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _loadEbooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEbooks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await _repository.fetchEbooks(
        category: _selectedCategory,
        search: _searchController.text,
      );
      if (mounted) {
        setState(() {
          _ebookResponse = res;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _loadEbooks,
        color: AppColors.webRed,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Search Input
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.cardBorder, width: 0.5),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: AppFontSizes.sm,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cari Judul...',
                      hintStyle: const TextStyle(
                        color: AppColors.textWhite54,
                        fontSize: AppFontSizes.sm,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.textWhite54,
                        size: 20,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                color: AppColors.textWhite54,
                                size: 18,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _loadEbooks();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                    ),
                    onSubmitted: (_) => _loadEbooks(),
                  ),
                ),
              ),
            ),

            // Category Horizontal Chips Filter
            if (_ebookResponse != null && _ebookResponse!.categories.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    height: 34,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildCategoryChip('Semua', 'all'),
                        ..._ebookResponse!.categories.map(
                          (cat) => _buildCategoryChip(cat.name, cat.slug),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Content Area
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.webRed),
                ),
              )
            else if (_errorMessage != null)
              SliverFillRemaining(child: _buildErrorWidget())
            else if (_ebookResponse == null || _ebookResponse!.ebooks.isEmpty)
              SliverFillRemaining(child: _buildEmptyWidget())
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final ebook = _ebookResponse!.ebooks[index];
                    return _buildEbookCard(ebook);
                  }, childCount: _ebookResponse!.ebooks.length),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, String slug) {
    final isSelected = _selectedCategory == slug;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          if (_selectedCategory != slug) {
            setState(() => _selectedCategory = slug);
            _loadEbooks();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.cardDark,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.cardBorder,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: AppFontSizes.xs,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEbookCard(EbookModel ebook) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: InkWell(
        onTap: () {
          context.push('/ebooks/${ebook.slug}/read', extra: ebook);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Small PDF Icon Box
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.webRed.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.webRed.withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: AppColors.webRed,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),

              // Title and Category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ebook.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (ebook.category != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        ebook.category!.name,
                        style: const TextStyle(
                          color: AppColors.textWhite54,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textWhite54,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.webRed),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Terjadi kesalahan saat memuat e-book.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textWhite, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.webRed,
              ),
              onPressed: _loadEbooks,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 48,
              color: AppColors.textWhite54,
            ),
            SizedBox(height: 16),
            Text(
              'Yah, belum ada E-Book yang tersedia :(',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textWhite70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
