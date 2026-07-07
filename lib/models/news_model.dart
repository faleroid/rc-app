class CreatorModel {
  final int id;
  final String name;

  CreatorModel({required this.id, required this.name});

  factory CreatorModel.fromJson(Map<String, dynamic> json) {
    return CreatorModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class NewsArticleModel {
  final int id;
  final String title;
  final String slug;
  final String excerpt;
  final String? content;
  final String thumbnail;
  final DateTime createdAt;
  final CreatorModel? creator;

  NewsArticleModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.excerpt,
    this.content,
    required this.thumbnail,
    required this.createdAt,
    this.creator,
  });

  factory NewsArticleModel.fromJson(Map<String, dynamic> json) {
    return NewsArticleModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      excerpt: json['excerpt'] ?? '',
      content: json['content'],
      thumbnail: json['thumbnail'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      creator: json['creator'] != null
          ? CreatorModel.fromJson(json['creator'])
          : null,
    );
  }
}

class NewsPaginatedResponse {
  final bool success;
  final List<NewsArticleModel> articles;
  final int currentPage;
  final String? nextPageUrl;

  NewsPaginatedResponse({
    required this.success,
    required this.articles,
    required this.currentPage,
    this.nextPageUrl,
  });

  factory NewsPaginatedResponse.fromJson(Map<String, dynamic> json) {
    final dataObject = json['data'] ?? {};
    final listData = dataObject['data'] as List? ?? [];

    return NewsPaginatedResponse(
      success: json['success'] ?? false,
      articles: listData.map((e) => NewsArticleModel.fromJson(e)).toList(),
      currentPage: dataObject['current_page'] ?? 1,
      nextPageUrl: dataObject['next_page_url'],
    );
  }
}

class NewsDetailResponse {
  final bool success;
  final NewsArticleModel data;

  NewsDetailResponse({
    required this.success,
    required this.data,
  });

  factory NewsDetailResponse.fromJson(Map<String, dynamic> json) {
    return NewsDetailResponse(
      success: json['success'] ?? false,
      data: NewsArticleModel.fromJson(json['data'] ?? {}),
    );
  }
}
