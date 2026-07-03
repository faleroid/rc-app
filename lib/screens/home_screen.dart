import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';
import '../models/card_model.dart';
import '../widgets/grid_modul_card.dart';
import '../widgets/description_card.dart';

class HomeScreen extends StatelessWidget {
  final List<CardModel> cards;

  const HomeScreen({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      text: "Edukasi Crypto Eksklusif untuk Mereka yang Siap",
                      style: AppTextStyles.heading,
                      children: <TextSpan>[
                        TextSpan(
                          text: " Profit Konsisten.",
                          style: AppTextStyles.headingAccent,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return GridModulCard(index: index, card: cards[index]);
              }, childCount: cards.length),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 24,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return DescriptionCard(index: index, card: cards[index]);
              }, childCount: cards.length),
            ),
          ),
        ],
      ),
    );
  }
}
