import 'package:flutter/material.dart';
import '../constants/margin.dart';
// ─────────────────────────────────────────────────────────────
// 9. GREY PLACEHOLDER BOX (untuk area belum ada konten/gambar)
// ─────────────────────────────────────────────────────────────
class PlaceholderBox extends StatelessWidget {
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  const PlaceholderBox({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: borderRadius ??
            BorderRadius.circular(AppRadius.md),
      ),
    );
  }
}