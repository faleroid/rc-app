import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/card_model.dart';

class DescriptionCard extends StatelessWidget {
  final int index;
  final CardModel card;

  const DescriptionCard({super.key, required this.index, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.cardDark,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              "${index + 1}",
              style: AppTextStyles.cardIndex,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              card.description,
              style: AppTextStyles.bodyWhite,
            ),
          ),
        ],
      ),
    );
  }
}
