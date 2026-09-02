import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_font_sizes.dart';
import '../models/signal_model.dart';
import '../repositories/signal_repository.dart';
import '../widgets/semi_circle_gauge_chart.dart';

class SignalPerformanceScreen extends StatefulWidget {
  const SignalPerformanceScreen({super.key});

  @override
  State<SignalPerformanceScreen> createState() =>
      _SignalPerformanceScreenState();
}

class _SignalPerformanceScreenState extends State<SignalPerformanceScreen> {
  final SignalRepository _repository = SignalRepository();

  bool _isLoading = true;
  String? _errorMessage;
  List<SignalMonthlyRecapModel> _recapList = [];

  @override
  void initState() {
    super.initState();
    _loadPerformance();
  }

  Future<void> _loadPerformance() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final recaps = await _repository.fetchMonthlyRecap();
      if (mounted) {
        setState(() {
          _recapList = recaps;
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
          'Performa Sinyal',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppFontSizes.lg,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadPerformance,
        color: AppColors.webRed,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.webRed),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.webRed),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textWhite, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.webRed,
                ),
                onPressed: _loadPerformance,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_recapList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pie_chart_outline, size: 48, color: AppColors.textWhite54),
              SizedBox(height: 16),
              Text(
                'Belum ada data rekap performa sinyal.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textWhite70, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _recapList.length,
      itemBuilder: (context, index) {
        final recap = _recapList[index];
        return _buildRecapCard(recap);
      },
    );
  }

  Widget _buildRecapCard(SignalMonthlyRecapModel recap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Month Name
          Text(
            recap.monthName,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.cardBorder, height: 1),
          const SizedBox(height: 16),

          // Main Row: Win Rate on Left, Chart on Right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Win Rate (Left side, no bg, no border)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${recap.winRate}%',
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Win Rate',
                    style: TextStyle(
                      color: AppColors.textWhite70,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // Semi Circle Gauge Chart
              SemiCircleGaugeChart(
                totalTrades: recap.totalSignals,
                wins: recap.winCount,
                losses: recap.loseCount,
                winRate: recap.winRate,
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
