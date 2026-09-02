import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SemiCircleGaugeChart extends StatelessWidget {
  final int totalTrades;
  final int wins;
  final int losses;
  final double winRate;

  const SemiCircleGaugeChart({
    super.key,
    required this.totalTrades,
    required this.wins,
    required this.losses,
    required this.winRate,
  });

  @override
  Widget build(BuildContext context) {
    final double totalResolved = (wins + losses).toDouble();
    final double winRatio = totalResolved > 0 ? wins / totalResolved : 0.0;
    final double lossRatio = totalResolved > 0 ? losses / totalResolved : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Semi-circle Gauge Arc with Center Text
        SizedBox(
          width: 140,
          height: 82,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              CustomPaint(
                size: const Size(140, 82),
                painter: _GaugePainter(
                  winRatio: winRatio,
                  lossRatio: lossRatio,
                ),
              ),
              Positioned(
                top: 26,
                child: Column(
                  children: [
                    Text(
                      '$totalTrades',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 1),
                    const Text(
                      'Trades',
                      style: TextStyle(
                        color: AppColors.textWhite70,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // Bottom Wins & Losses Stats with neat spacing
        SizedBox(
          width: 130,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    '$wins',
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'Wins',
                    style: TextStyle(
                      color: AppColors.textWhite70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '$losses',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'Losses',
                    style: TextStyle(
                      color: AppColors.textWhite70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double winRatio;
  final double lossRatio;

  _GaugePainter({required this.winRatio, required this.lossRatio});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 11.0;
    final center = Offset(size.width / 2, size.height - 8);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    const startAngle = math.pi; // 180 degrees (left)
    const totalSweep = math.pi; // 180 degrees sweep (top half circle)

    // Track Paint (Background dark ring)
    final trackPaint = Paint()
      ..color = const Color(0xFF262626)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, totalSweep, false, trackPaint);

    if (winRatio <= 0 && lossRatio <= 0) {
      return;
    }

    // Win Arc Paint (Green)
    final winSweep = totalSweep * winRatio;
    if (winSweep > 0) {
      final winPaint = Paint()
        ..color =
            const Color(0xFF10B981) // Vibrant green
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle, winSweep, false, winPaint);
    }

    // Loss Arc Paint (Red)
    final lossSweep = totalSweep * lossRatio;
    if (lossSweep > 0) {
      final lossStartAngle = startAngle + winSweep;
      final lossPaint = Paint()
        ..color =
            const Color(0xFFEF4444) // Vibrant red
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, lossStartAngle, lossSweep, false, lossPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.winRatio != winRatio ||
        oldDelegate.lossRatio != lossRatio;
  }
}
