class NewsArticleModel {
  final String id;
  final String title;
  final String description;
  final String link;
  final String source;
  final String? sourceKey;
  final String? language;
  final String? pubDate;
  final String? category;
  final String? region;
  final String? timeAgo;

  NewsArticleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.link,
    required this.source,
    this.sourceKey,
    this.language,
    this.pubDate,
    this.category,
    this.region,
    this.timeAgo,
  });

  factory NewsArticleModel.fromJson(Map<String, dynamic> json) {
    return NewsArticleModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      link: json['link'] ?? '',
      source: json['source'] ?? 'Public News',
      sourceKey: json['sourceKey'],
      language: json['language'],
      pubDate: json['pubDate'],
      category: json['category'],
      region: json['region'],
      timeAgo: json['timeAgo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'link': link,
      'source': source,
      'sourceKey': sourceKey,
      'language': language,
      'pubDate': pubDate,
      'category': category,
      'region': region,
      'timeAgo': timeAgo,
    };
  }
}

class NewsPaginatedResponse {
  final bool success;
  final List<NewsArticleModel> articles;

  NewsPaginatedResponse({
    required this.success,
    required this.articles,
  });

  factory NewsPaginatedResponse.fromJson(Map<String, dynamic> json) {
    final dataObject = json['data'];
    List listData = [];

    if (dataObject is Map<String, dynamic>) {
      listData = dataObject['articles'] as List? ?? [];
    } else if (dataObject is List) {
      listData = dataObject;
    } else if (json['articles'] is List) {
      listData = json['articles'] as List;
    }

    return NewsPaginatedResponse(
      success: json['success'] ?? true,
      articles: listData.map((e) => NewsArticleModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
