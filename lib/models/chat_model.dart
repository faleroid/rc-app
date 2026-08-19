class ChatSourceModel {
  final int? moduleId;
  final String moduleTitle;
  final String courseTitle;

  ChatSourceModel({
    this.moduleId,
    required this.moduleTitle,
    required this.courseTitle,
  });

  factory ChatSourceModel.fromJson(Map<String, dynamic> json) {
    return ChatSourceModel(
      moduleId: json['module_id'],
      moduleTitle: json['module_title'] ?? '',
      courseTitle: json['course_title'] ?? '',
    );
  }
}

class ChatMessageModel {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isInScope;
  final List<ChatSourceModel> sources;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isInScope = true,
    this.sources = const [],
  });

  factory ChatMessageModel.user(String text) {
    return ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
  }

  factory ChatMessageModel.bot({
    required String text,
    bool isInScope = true,
    List<ChatSourceModel> sources = const [],
  }) {
    return ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: false,
      timestamp: DateTime.now(),
      isInScope: isInScope,
      sources: sources,
    );
  }
}
