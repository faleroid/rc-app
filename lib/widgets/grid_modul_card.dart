import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/card_model.dart';

class GridModulCard extends StatelessWidget {
  final int index;
  final CardModel card;

  const GridModulCard({super.key, required this.index, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gridCardBorder, width: 1),
        image: DecorationImage(
          image: NetworkImage(card.imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.imageOverlay,
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "${index + 1}",
                  style: AppTextStyles.cardIndex,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  card.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
