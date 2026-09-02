import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../models/signal_model.dart';
import '../repositories/signal_repository.dart';

class SignalsScreen extends StatefulWidget {
  const SignalsScreen({super.key});

  @override
  State<SignalsScreen> createState() => _SignalsScreenState();
}

class _SignalsScreenState extends State<SignalsScreen> {
  final SignalRepository _repository = SignalRepository();

  bool _isLoading = true;
  String? _errorMessage;
  SignalListResponse? _signalResponse;

  final String _selectedStatus = 'active';
  String _selectedType = 'all'; // 'all', 'Futures', or 'Spot'

  @override
  void initState() {
    super.initState();
    _loadSignals();
  }

  Future<void> _loadSignals({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await _repository.fetchSignals(
        status: _selectedStatus,
        type: _selectedType,
        forceRefresh: forceRefresh,
      );
      if (mounted) {
        setState(() {
          _signalResponse = res;
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
        onRefresh: () => _loadSignals(forceRefresh: true),
        color: AppColors.webRed,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Stats Header Card
            SliverToBoxAdapter(child: _buildStatsHeader()),

            // Filter Tabs (Semua, Futures, Spot)
            SliverToBoxAdapter(child: _buildFilterTabs()),

            // Content Area
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.webRed),
                ),
              )
            else if (_errorMessage != null)
              SliverFillRemaining(child: _buildErrorWidget())
            else if (_signalResponse == null ||
                _signalResponse!.signals.isEmpty)
              SliverFillRemaining(child: _buildEmptyWidget())
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final signal = _signalResponse!.signals[index];
                    return _buildSignalCard(signal);
                  }, childCount: _signalResponse!.signals.length),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsHeader() {
    final stats = _signalResponse?.stats;
    final active = stats?.active ?? 0;
    final total = stats?.total ?? 0;
    final hitTp = stats?.hitTp ?? 0;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          // Stats Items Grid Row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Sinyal Aktif',
                  active.toString(),
                  AppColors.textWhite,
                ),
                _buildStatItem('Profit', hitTp.toString(), AppColors.textWhite),
                _buildStatItem(
                  'Total Sinyal',
                  total.toString(),
                  AppColors.textWhite,
                ),
              ],
            ),
          ),

          // Bottom Performance Button Row (With Top Border)
          InkWell(
            onTap: () {
              context.push('/signals/performance');
            },
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.cardBorder, width: 1.0),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        color: AppColors.textWhite70,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Lihat Performa',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textWhite70,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.textWhite70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          _buildTypeTabItem('Semua', 'all'),
          _buildTypeTabItem('Futures', 'Futures'),
          _buildTypeTabItem('Spot', 'Spot'),
        ],
      ),
    );
  }

  Widget _buildTypeTabItem(String label, String typeKey) {
    final isSelected = _selectedType == typeKey;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_selectedType != typeKey) {
            setState(() {
              _selectedType = typeKey;
            });
            _loadSignals();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.webRed : Colors.transparent,
                width: 2.0,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.webRed : AppColors.textWhite70,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignalCard(SignalModel signal) {
    final isLong = signal.side.toUpperCase() == 'LONG';
    final sideColor = isLong ? Colors.greenAccent : Colors.redAccent;

    final statusLower = signal.status.toLowerCase();
    Gradient? cardGradient;

    if (statusLower.startsWith('hit_tp')) {
      cardGradient = RadialGradient(
        center: Alignment.topRight,
        radius: 1.2,
        colors: [
          Colors.greenAccent.withValues(alpha: 0.16),
          Colors.greenAccent.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      );
    } else if (statusLower == 'hit_sl') {
      cardGradient = RadialGradient(
        center: Alignment.topRight,
        radius: 1.2,
        colors: [
          Colors.redAccent.withValues(alpha: 0.16),
          Colors.redAccent.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      );
    } else {
      cardGradient = RadialGradient(
        center: Alignment.topRight,
        radius: 1.2,
        colors: [Colors.transparent, Colors.transparent, Colors.transparent],
        stops: const [0.0, 0.5, 1.0],
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Pair & Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    signal.pair,
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: sideColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: sideColor.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      signal.side,
                      style: TextStyle(
                        color: sideColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      ),
                    ),
                  ),
                  if (signal.leverage != null &&
                      signal.leverage!.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        signal.leverage!,
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              _buildStatusBadge(signal.status),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.cardBorder, height: 1),
          const SizedBox(height: 12),

          // Targets Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Entry Targets
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Target Entry',
                      style: TextStyle(
                        color: AppColors.textWhite70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      signal.entryTargets.isNotEmpty
                          ? signal.entryTargets.join(' - ')
                          : '-',
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Stop Loss
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stop Loss',
                      style: TextStyle(
                        color: AppColors.textWhite70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      signal.stopLoss ?? '-',
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Take Profit Targets
          const Text(
            'Take Profit',
            style: TextStyle(color: AppColors.textWhite70, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: signal.tpTargets.asMap().entries.map((entry) {
              final idx = entry.key + 1;
              final val = entry.value;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  'TP$idx: $val',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                signal.type.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textWhite54,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                signal.timeAgo ?? signal.formattedDate ?? '',
                style: const TextStyle(
                  color: AppColors.textWhite54,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status.toLowerCase()) {
      case 'active':
        color = Colors.blueAccent;
        label = 'AKTIF';
        break;
      case 'hit_tp1':
      case 'hit_tp2':
      case 'hit_tp3':
      case 'hit_tp4':
      case 'hit_tp5':
      case 'hit_tp_swing':
        color = Colors.greenAccent;
        label = status.toUpperCase().replaceAll('_', ' ');
        break;
      case 'hit_sl':
        color = Colors.redAccent;
        label = 'HIT SL';
        break;
      case 'closed':
        color = Colors.grey;
        label = 'SELESAI';
        break;
      case 'cancelled':
        color = Colors.orangeAccent;
        label = 'BATAL';
        break;
      default:
        color = Colors.grey;
        label = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.bold,
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
              _errorMessage ?? 'Terjadi kesalahan saat memuat sinyal.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textWhite, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.webRed,
              ),
              onPressed: _loadSignals,
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
            Icon(Icons.query_stats, size: 48, color: AppColors.textWhite54),
            SizedBox(height: 16),
            Text(
              'Sabar yaa, admin sedang mempersiapkan sinyal selanjutnya !',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textWhite70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
