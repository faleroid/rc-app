class AnnouncementAuthorModel {
  final int id;
  final String name;

  AnnouncementAuthorModel({
    required this.id,
    required this.name,
  });

  factory AnnouncementAuthorModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementAuthorModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class AnnouncementModel {
  final int id;
  final String title;
  final String content;
  final String category;
  final String? imageUrl;
  final String? actionUrl;
  final String? actionLabel;
  final bool isPinned;
  final int likesCount;
  final bool isLiked;
  final String? createdAt;
  final String? formattedDate;
  final String? timeAgo;
  final AnnouncementAuthorModel? author;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.imageUrl,
    this.actionUrl,
    this.actionLabel,
    this.isPinned = false,
    this.likesCount = 0,
    this.isLiked = false,
    this.createdAt,
    this.formattedDate,
    this.timeAgo,
    this.author,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? 'general',
      imageUrl: json['image_url'],
      actionUrl: json['action_url'],
      actionLabel: json['action_label'],
      isPinned: json['is_pinned'] == true || json['is_pinned'] == 1,
      likesCount: json['likes_count'] is int ? json['likes_count'] : int.tryParse(json['likes_count']?.toString() ?? '0') ?? 0,
      isLiked: json['is_liked'] == true || json['is_liked'] == 1,
      createdAt: json['created_at'],
      formattedDate: json['formatted_date'],
      timeAgo: json['time_ago'],
      author: json['author'] != null ? AnnouncementAuthorModel.fromJson(json['author']) : null,
    );
  }

  AnnouncementModel copyWith({
    int? id,
    String? title,
    String? content,
    String? category,
    String? imageUrl,
    String? actionUrl,
    String? actionLabel,
    bool? isPinned,
    int? likesCount,
    bool? isLiked,
    String? createdAt,
    String? formattedDate,
    String? timeAgo,
    AnnouncementAuthorModel? author,
  }) {
    return AnnouncementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      actionLabel: actionLabel ?? this.actionLabel,
      isPinned: isPinned ?? this.isPinned,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      formattedDate: formattedDate ?? this.formattedDate,
      timeAgo: timeAgo ?? this.timeAgo,
      author: author ?? this.author,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'image_url': imageUrl,
      'action_url': actionUrl,
      'action_label': actionLabel,
      'is_pinned': isPinned,
      'likes_count': likesCount,
      'is_liked': isLiked,
      'created_at': createdAt,
      'formatted_date': formattedDate,
      'time_ago': timeAgo,
      'author': author?.toJson(),
    };
  }
}

class AnnouncementListResponse {
  final bool success;
  final List<AnnouncementModel> announcements;
  final int currentPage;
  final int lastPage;
  final int total;

  AnnouncementListResponse({
    required this.success,
    required this.announcements,
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
  });

  factory AnnouncementListResponse.fromJson(Map<String, dynamic> json) {
    final dataObj = json['data'];
    List list = [];
    int curPage = 1;
    int lstPage = 1;
    int tot = 0;

    if (dataObj is Map<String, dynamic>) {
      list = dataObj['announcements'] as List? ?? [];
      curPage = dataObj['current_page'] is int ? dataObj['current_page'] : 1;
      lstPage = dataObj['last_page'] is int ? dataObj['last_page'] : 1;
      tot = dataObj['total'] is int ? dataObj['total'] : list.length;
    } else if (dataObj is List) {
      list = dataObj;
      tot = list.length;
    }

    return AnnouncementListResponse(
      success: json['success'] ?? true,
      announcements: list.map((e) => AnnouncementModel.fromJson(e as Map<String, dynamic>)).toList(),
      currentPage: curPage,
      lastPage: lstPage,
      total: tot,
    );
  }
}
