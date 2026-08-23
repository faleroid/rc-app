import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/announcement_model.dart';
import '../repositories/announcement_repository.dart';

class AnnouncementTrackerService {
  static final AnnouncementTrackerService _instance =
      AnnouncementTrackerService._internal();
  factory AnnouncementTrackerService() => _instance;
  AnnouncementTrackerService._internal();

  final _storage = const FlutterSecureStorage();
  static const String _readIdsKey = 'read_announcement_ids';

  /// Real-time ValueNotifier for unread announcements count
  final ValueNotifier<int> unreadCountNotifier = ValueNotifier<int>(0);

  final AnnouncementRepository _repository = AnnouncementRepository();

  Future<Set<int>> getReadIds() async {
    try {
      final raw = await _storage.read(key: _readIdsKey);
      if (raw != null && raw.isNotEmpty) {
        final List list = jsonDecode(raw);
        return list.map((e) => int.tryParse(e.toString()) ?? 0).toSet();
      }
    } catch (_) {}
    return <int>{};
  }

  Future<void> checkUnreadAnnouncements() async {
    try {
      final response = await _repository.fetchAnnouncements(
        page: 1,
        perPage: 20,
      );
      final readIds = await getReadIds();

      int unread = 0;
      for (final a in response.announcements) {
        if (!readIds.contains(a.id)) {
          unread++;
        }
      }
      unreadCountNotifier.value = unread;
    } catch (_) {
      // Ignore network errors on background check
    }
  }

  Future<void> markAllAsRead(List<AnnouncementModel> announcements) async {
    try {
      final readIds = await getReadIds();
      for (final a in announcements) {
        readIds.add(a.id);
      }
      await _storage.write(
        key: _readIdsKey,
        value: jsonEncode(readIds.toList()),
      );
      unreadCountNotifier.value = 0;
    } catch (_) {}
  }

  Future<void> markAllCurrentAsRead() async {
    try {
      final response = await _repository.fetchAnnouncements(
        page: 1,
        perPage: 20,
      );
      await markAllAsRead(response.announcements);
    } catch (_) {
      unreadCountNotifier.value = 0;
    }
  }
}
