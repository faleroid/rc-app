import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../models/signal_model.dart';
import '../repositories/signal_repository.dart';
import '../repositories/profile_repository.dart';

class SignalsScreen extends StatefulWidget {
  const SignalsScreen({super.key});

  @override
  State<SignalsScreen> createState() => _SignalsScreenState();
}

class _SignalsScreenState extends State<SignalsScreen> {
  final SignalRepository _repository = SignalRepository();
  final ProfileRepository _profileRepo = ProfileRepository();

  bool _isLoading = true;
  bool _isAdmin = false;
  String? _errorMessage;
  SignalListResponse? _signalResponse;

  final String _selectedStatus = 'active';
  String _selectedType = 'all'; // 'all', 'Futures', or 'Spot'

  @override
  void initState() {
    super.initState();
    _checkAdminRole();
    _loadSignals();
  }

  Future<void> _checkAdminRole() async {
    try {
      final res = await _profileRepo.getProfile();
      if (res.data != null && mounted) {
        setState(() {
          _isAdmin = res.data!.role.toLowerCase() == 'admin';
        });
      }
    } catch (_) {}
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

    final cardContent = Container(
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

    if (!_isAdmin) {
      return cardContent;
    }

    // Dismissible for Admin role (Swipe Right: Edit Status, Swipe Left: Delete)
    return Dismissible(
      key: ValueKey('signal_${signal.id}'),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Swipe Right -> Edit Status Modal
          await _showEditStatusModal(signal);
          return false; // Don't remove widget from list automatically
        } else if (direction == DismissDirection.endToStart) {
          // Swipe Left -> Confirm Delete
          return await _confirmDeleteSignal(signal);
        }
        return false;
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1D4ED8), // Deep vibrant blue
              Color(0xFF3B82F6), // Bright modern blue
              Color(0xFF60A5FA), // Light blue accent
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Row(
          children: [
            Icon(Icons.edit_note_rounded, color: Colors.white, size: 28),
            SizedBox(width: 8),
            Text(
              'Ubah Status',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF87171), // Light red accent
              Color(0xFFEF4444), // Vibrant red
              Color(0xFFB91C1C), // Deep crimson red
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Hapus Sinyal',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.delete_forever_rounded, color: Colors.white, size: 28),
          ],
        ),
      ),
      child: cardContent,
    );
  }

  Future<void> _showEditStatusModal(SignalModel signal) async {
    final List<Map<String, dynamic>> statusOptions = [
      {'value': 'active', 'label': 'AKTIF', 'color': Colors.blueAccent},
    ];

    // Generate Hit TP options dynamically based on the signal's TP targets
    final tpCount = signal.tpTargets.length;
    for (int i = 1; i <= tpCount; i++) {
      statusOptions.add({
        'value': 'hit_tp$i',
        'label': 'HIT TP$i (${signal.tpTargets[i - 1]})',
        'color': Colors.greenAccent,
      });
    }

    // Stop Loss option
    statusOptions.add({
      'value': 'hit_sl',
      'label': signal.stopLoss != null && signal.stopLoss!.isNotEmpty
          ? 'HIT STOP LOSS (${signal.stopLoss})'
          : 'HIT STOP LOSS (SL)',
      'color': Colors.redAccent,
    });

    // Closed and Cancelled
    statusOptions.add({
      'value': 'closed',
      'label': 'SELESAI (CLOSED)',
      'color': Colors.grey,
    });

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Update Status: ${signal.pair}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white54,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const Divider(color: AppColors.cardBorder),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: statusOptions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final opt = statusOptions[index];
                      final isCurrent =
                          signal.status.toLowerCase() == opt['value'];
                      final color = opt['color'] as Color;

                      return ListTile(
                        dense: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: isCurrent ? color : AppColors.cardBorder,
                            width: isCurrent ? 1.5 : 1,
                          ),
                        ),
                        tileColor: isCurrent
                            ? color.withValues(alpha: 0.15)
                            : AppColors.background,
                        leading: Icon(
                          isCurrent
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isCurrent ? color : Colors.white54,
                          size: 20,
                        ),
                        title: Text(
                          opt['label'] as String,
                          style: TextStyle(
                            color: isCurrent ? Colors.white : Colors.white70,
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        onTap: () async {
                          Navigator.of(ctx).pop();
                          if (!isCurrent) {
                            await _updateStatus(
                              signal.id,
                              opt['value'] as String,
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateStatus(int id, String newStatus) async {
    try {
      await _repository.updateSignalStatus(id, newStatus);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Status sinyal berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );
      _loadSignals(forceRefresh: true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: AppColors.webRed,
        ),
      );
    }
  }

  Future<bool> _confirmDeleteSignal(SignalModel signal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Hapus Sinyal?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus sinyal ${signal.pair} (${signal.type}) ini?',
          style: const TextStyle(color: AppColors.textWhite70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.webRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _repository.deleteSignal(signal.id);
        if (!mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sinyal ${signal.pair} berhasil dihapus!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadSignals(forceRefresh: true);
        return true;
      } catch (e) {
        if (!mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.webRed,
          ),
        );
        return false;
      }
    }
    return false;
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
