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
      moduleTitle: json['module_title']?.toString() ?? '',
      courseTitle: json['course_title']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'module_id': moduleId,
      'module_title': moduleTitle,
      'course_title': courseTitle,
    };
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

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    var rawSources = json['sources'] as List<dynamic>? ?? [];
    List<ChatSourceModel> parsedSources = rawSources.map((s) {
      if (s is Map) {
        return ChatSourceModel.fromJson(Map<String, dynamic>.from(s));
      }
      return ChatSourceModel(moduleTitle: '', courseTitle: '');
    }).toList();

    return ChatMessageModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      text: json['text'] ?? '',
      isUser: json['is_user'] ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isInScope: json['is_in_scope'] ?? true,
      sources: parsedSources,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'is_user': isUser,
      'timestamp': timestamp.toIso8601String(),
      'is_in_scope': isInScope,
      'sources': sources.map((s) => s.toJson()).toList(),
    };
  }
}
