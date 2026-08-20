import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/chat_model.dart';

class ChatHistoryService {
  static const String _keyHistoryData = 'rc_chat_history_data_v1';
  static const String _keyHistoryTimestamp = 'rc_chat_history_timestamp_v1';

  final FlutterSecureStorage _storage;

  ChatHistoryService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Save current list of chat messages along with current timestamp.
  Future<void> saveMessages(List<ChatMessageModel> messages) async {
    try {
      if (messages.isEmpty) {
        await clearHistory();
        return;
      }

      final jsonList = messages.map((m) => m.toJson()).toList();
      final jsonString = jsonEncode(jsonList);

      await _storage.write(key: _keyHistoryData, value: jsonString);
      await _storage.write(
        key: _keyHistoryTimestamp,
        value: DateTime.now().toIso8601String(),
      );
    } catch (_) {
      // Ignore storage errors gracefully
    }
  }

  /// Load saved chat messages if saved within the last 24 hours.
  /// If older than 24 hours, automatically clears the history and returns empty list.
  Future<List<ChatMessageModel>> loadMessages() async {
    try {
      final timestampStr = await _storage.read(key: _keyHistoryTimestamp);
      final jsonString = await _storage.read(key: _keyHistoryData);

      if (timestampStr == null || jsonString == null) {
        return [];
      }

      final savedTime = DateTime.tryParse(timestampStr);
      if (savedTime == null) {
        await clearHistory();
        return [];
      }

      // Check if history is older than 24 hours
      final hoursDifference = DateTime.now().difference(savedTime).inHours;
      if (hoursDifference >= 24) {
        await clearHistory();
        return [];
      }

      final List<dynamic> decodedList = jsonDecode(jsonString);
      return decodedList
          .map((item) => ChatMessageModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      await clearHistory();
      return [];
    }
  }

  /// Manually clear saved chat history.
  Future<void> clearHistory() async {
    try {
      await _storage.delete(key: _keyHistoryData);
      await _storage.delete(key: _keyHistoryTimestamp);
    } catch (_) {}
  }
}
