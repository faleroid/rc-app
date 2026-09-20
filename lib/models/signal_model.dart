class SignalModel {
  final int id;
  final String pair;
  final String type;
  final String side;
  final String? leverage;
  final List<String> entryTargets;
  final List<String> tpTargets;
  final String? stopLoss;
  final String status;
  final String? notes;
  final String? createdAt;
  final String? formattedDate;
  final String? timeAgo;

  SignalModel({
    required this.id,
    required this.pair,
    required this.type,
    required this.side,
    this.leverage,
    required this.entryTargets,
    required this.tpTargets,
    this.stopLoss,
    required this.status,
    this.notes,
    this.createdAt,
    this.formattedDate,
    this.timeAgo,
  });

  factory SignalModel.fromJson(Map<String, dynamic> json) {
    return SignalModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      pair: json['pair'] ?? '',
      type: json['type'] ?? 'Spot',
      side: json['side'] ?? 'LONG',
      leverage: json['leverage']?.toString(),
      entryTargets:
          (json['entry_targets'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      tpTargets:
          (json['tp_targets'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      stopLoss: json['stop_loss']?.toString(),
      status: json['status'] ?? 'active',
      notes: json['notes']?.toString(),
      createdAt: json['created_at']?.toString(),
      formattedDate: json['formatted_date']?.toString(),
      timeAgo: json['time_ago']?.toString(),
    );
  }
}

class SignalStats {
  final int active;
  final int total;
  final int hitTp;

  SignalStats({required this.active, required this.total, required this.hitTp});

  factory SignalStats.fromJson(Map<String, dynamic> json) {
    return SignalStats(
      active: json['active'] ?? 0,
      total: json['total'] ?? 0,
      hitTp: json['hit_tp'] ?? 0,
    );
  }
}

class SignalListResponse {
  final bool success;
  final String? message;
  final List<SignalModel> signals;
  final SignalStats? stats;
  final int currentPage;
  final int lastPage;
  final int total;

  SignalListResponse({
    required this.success,
    this.message,
    required this.signals,
    this.stats,
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
  });

  factory SignalListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final rawSignals = data['signals'] as List<dynamic>? ?? [];
    final rawStats = data['stats'] as Map<String, dynamic>?;

    return SignalListResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString(),
      signals: rawSignals.map((e) => SignalModel.fromJson(e)).toList(),
      stats: rawStats != null ? SignalStats.fromJson(rawStats) : null,
      currentPage: data['current_page'] ?? 1,
      lastPage: data['last_page'] ?? 1,
      total: data['total'] ?? 0,
    );
  }
}

class SignalMonthlyRecapModel {
  final String monthKey;
  final String monthName;
  final int totalSignals;
  final int winCount;
  final int loseCount;
  final int activeCount;
  final double winRate;

  SignalMonthlyRecapModel({
    required this.monthKey,
    required this.monthName,
    required this.totalSignals,
    required this.winCount,
    required this.loseCount,
    required this.activeCount,
    required this.winRate,
  });

  factory SignalMonthlyRecapModel.fromJson(Map<String, dynamic> json) {
    return SignalMonthlyRecapModel(
      monthKey: json['month_key'] ?? '',
      monthName: json['month_name'] ?? '',
      totalSignals: json['total_signals'] ?? 0,
      winCount: json['win_count'] ?? 0,
      loseCount: json['lose_count'] ?? 0,
      activeCount: json['active_count'] ?? 0,
      winRate: (json['win_rate'] is num)
          ? (json['win_rate'] as num).toDouble()
          : double.tryParse(json['win_rate'].toString()) ?? 0.0,
    );
  }
}
