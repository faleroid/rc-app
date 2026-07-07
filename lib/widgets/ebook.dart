import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/strings.dart';
import '../constants/margin.dart';
import '../constants/font.dart';
// ─────────────────────────────────────────────────────────────
// 5. MODUL EBOOK CARD (Grid Item)
// ─────────────────────────────────────────────────────────────
class ModulEbookCard extends StatelessWidget {
  final String title;
  final String? imagePath;
  final VoidCallback? onTap;

  const ModulEbookCard({
    super.key,
    this.title = AppStrings.sectionModulEbook,
    this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardModul,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.md),
                ),
                child: imagePath != null
                    ? Image.asset(
                  imagePath!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _placeholderThumbnail(),
                )
                    : _placeholderThumbnail(),
              ),
            ),
            // Label
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Center(
                      child: Text(
                        '1',
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: AppFontSizes.xs,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: AppFontSizes.sm,
                      fontFamily: AppFonts.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderThumbnail() {
    return Container(
      color: AppColors.cardBorder,
      child: const Center(
        child: Icon(Icons.menu_book,
            color: AppColors.textWhite54, size: 32),
      ),
    );
  }
}