import 'package:dio/dio.dart';
import '../models/chat_model.dart';
import '../services/api_service.dart';

class ChatRepository {
  final ApiService _apiService = ApiService();

  /// Send student question to backend POST /api/chat
  Future<ChatMessageModel> askQuestion({
    required String question,
    int? courseId,
    int? moduleId,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/chat',
        data: {
          'question': question,
          'course_id': ?courseId,
          'module_id': ?moduleId,
        },
      );

      final data = response.data['data'];
      final answer = data['answer'] ?? 'Tidak ada tanggapan.';
      final isInScope = data['is_in_scope'] ?? false;
      final rawSources = data['sources'] as List<dynamic>? ?? [];

      final sources = rawSources.map((s) => ChatSourceModel.fromJson(s)).toList();

      return ChatMessageModel.bot(
        text: answer,
        isInScope: isInScope,
        sources: sources,
      );
    } on DioException catch (e) {
      String errorMsg = 'Gagal menghubungi AI Asisten. Silakan coba lagi.';
      if (e.response?.data is Map && e.response?.data['message'] != null) {
        errorMsg = e.response!.data['message'].toString();
      }
      return ChatMessageModel.bot(
        text: errorMsg,
        isInScope: false,
      );
    } catch (e) {
      return ChatMessageModel.bot(
        text: 'Terjadi kesalahan sistem: $e',
        isInScope: false,
      );
    }
  }
}
