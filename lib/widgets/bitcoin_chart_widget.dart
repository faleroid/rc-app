import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../repositories/bitcoin_repository.dart';
import '../constants/app_colors.dart';
import '../constants/app_font_sizes.dart';

class BitcoinChartWidget extends StatefulWidget {
  const BitcoinChartWidget({super.key});

  @override
  State<BitcoinChartWidget> createState() => _BitcoinChartWidgetState();
}

class _BitcoinChartWidgetState extends State<BitcoinChartWidget> {
  final BitcoinRepository _bitcoinRepository = BitcoinRepository();
  BitcoinData? _bitcoinData;
  bool _isLoading = true;
  String? _error;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchData();
    // Auto-refresh setiap 60 detik
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _fetchData();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final data = await _bitcoinRepository.fetchBitcoinData();
      if (mounted) {
        setState(() {
          _bitcoinData = data;
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: _isLoading
          ? const SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          : _error != null
          ? SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white54,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gagal memuat data Bitcoin',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: AppFontSizes.sm,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLoading = true;
                          _error = null;
                        });
                        _fetchData();
                      },
                      child: const Text(
                        'Coba Lagi',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: AppFontSizes.sm,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : _buildChart(),
    );
  }

  Widget _buildChart() {
    final data = _bitcoinData!;
    final isPositive = data.priceChange24h >= 0;
    final chartColor = isPositive ? Colors.greenAccent : Colors.redAccent;
    final priceFormatted = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    ).format(data.currentPrice);
    final changeFormatted = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    ).format(data.priceChange24h.abs());
    final percentFormatted = data.priceChangePercentage24h
        .abs()
        .toStringAsFixed(2);

    // Buat data titik untuk chart
    final spots = <FlSpot>[];
    for (int i = 0; i < data.priceHistory.length; i++) {
      spots.add(FlSpot(i.toDouble(), data.priceHistory[i].price));
    }

    final minY = data.priceHistory
        .map((e) => e.price)
        .reduce((a, b) => a < b ? a : b);
    final maxY = data.priceHistory
        .map((e) => e.price)
        .reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: Bitcoin info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BTC/USD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppFontSizes.md,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '7 Hari Terakhir',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: AppFontSizes.xs,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    priceFormatted,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppFontSizes.lg,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive ? Icons.trending_up : Icons.trending_down,
                          color: chartColor,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$changeFormatted ($percentFormatted%)',
                          style: TextStyle(
                            color: chartColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Chart
        SizedBox(
          height: 150,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (spots.length - 1).toDouble(),
              minY: minY - padding,
              maxY: maxY + padding,
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) => Colors.black87,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final price = NumberFormat.currency(
                        symbol: '\$',
                        decimalDigits: 2,
                      ).format(spot.y);
                      final idx = spot.x.toInt();
                      final date = idx < data.priceHistory.length
                          ? DateFormat(
                              'd MMM',
                            ).format(data.priceHistory[idx].time)
                          : '';
                      return LineTooltipItem(
                        '$price\n',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: date,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.35,
                  color: chartColor,
                  barWidth: 2.0,
                  isStrokeCapRound: true,
                  shadow: Shadow(
                    color: chartColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        chartColor.withValues(alpha: 0.3),
                        chartColor.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Footer: Last update
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.access_time, size: 12, color: Colors.white38),
              const SizedBox(width: 4),
              Text(
                'Update: ${DateFormat('HH:mm').format(DateTime.now())}',
                style: const TextStyle(color: Colors.white38, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
