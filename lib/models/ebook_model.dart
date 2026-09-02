class EbookCategoryModel {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final int ebooksCount;

  EbookCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.ebooksCount = 0,
  });

  factory EbookCategoryModel.fromJson(Map<String, dynamic> json) {
    return EbookCategoryModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description']?.toString(),
      ebooksCount: json['ebooks_count'] ?? 0,
    );
  }
}

class EbookModel {
  final int id;
  final String title;
  final String slug;
  final String? author;
  final String? description;
  final String? pdfUrl;
  final int? fileSize;
  final String? formattedFileSize;
  final int? pageCount;
  final bool isFeatured;
  final bool isVipOnly;
  final String status;
  final int viewsCount;
  final int downloadCount;
  final EbookCategoryModel? category;
  final String? publishedAt;
  final String? formattedDate;
  final String? timeAgo;

  EbookModel({
    required this.id,
    required this.title,
    required this.slug,
    this.author,
    this.description,
    this.pdfUrl,
    this.fileSize,
    this.formattedFileSize,
    this.pageCount,
    this.isFeatured = false,
    this.isVipOnly = true,
    required this.status,
    this.viewsCount = 0,
    this.downloadCount = 0,
    this.category,
    this.publishedAt,
    this.formattedDate,
    this.timeAgo,
  });

  factory EbookModel.fromJson(Map<String, dynamic> json) {
    return EbookModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      author: json['author']?.toString(),
      description: json['description']?.toString(),
      pdfUrl: json['pdf_url']?.toString(),
      fileSize: json['file_size'] as int?,
      formattedFileSize: json['formatted_file_size']?.toString(),
      pageCount: json['page_count'] as int?,
      isFeatured: json['is_featured'] ?? false,
      isVipOnly: json['is_vip_only'] ?? true,
      status: json['status'] ?? 'published',
      viewsCount: json['views_count'] ?? 0,
      downloadCount: json['download_count'] ?? 0,
      category: json['category'] != null && json['category'] is Map
          ? EbookCategoryModel.fromJson(json['category'])
          : null,
      publishedAt: json['published_at']?.toString(),
      formattedDate: json['formatted_date']?.toString(),
      timeAgo: json['time_ago']?.toString(),
    );
  }
}

class EbookStats {
  final int totalEbooks;
  final int totalCategories;

  EbookStats({
    required this.totalEbooks,
    required this.totalCategories,
  });

  factory EbookStats.fromJson(Map<String, dynamic> json) {
    return EbookStats(
      totalEbooks: json['total_ebooks'] ?? 0,
      totalCategories: json['total_categories'] ?? 0,
    );
  }
}

class EbookListResponse {
  final bool success;
  final String? message;
  final List<EbookModel> ebooks;
  final List<EbookCategoryModel> categories;
  final EbookStats? stats;
  final int currentPage;
  final int lastPage;
  final int total;

  EbookListResponse({
    required this.success,
    this.message,
    required this.ebooks,
    required this.categories,
    this.stats,
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
  });

  factory EbookListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final rawEbooks = data['ebooks'] as List<dynamic>? ?? [];
    final rawCategories = data['categories'] as List<dynamic>? ?? [];
    final rawStats = data['stats'] as Map<String, dynamic>?;

    return EbookListResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString(),
      ebooks: rawEbooks.map((e) => EbookModel.fromJson(e)).toList(),
      categories:
          rawCategories.map((e) => EbookCategoryModel.fromJson(e)).toList(),
      stats: rawStats != null ? EbookStats.fromJson(rawStats) : null,
      currentPage: data['current_page'] ?? 1,
      lastPage: data['last_page'] ?? 1,
      total: data['total'] ?? 0,
    );
  }
}

class EbookDetailResponse {
  final bool success;
  final String? message;
  final EbookModel? ebook;
  final List<EbookModel> relatedEbooks;

  EbookDetailResponse({
    required this.success,
    this.message,
    this.ebook,
    this.relatedEbooks = const [],
  });

  factory EbookDetailResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final rawEbook = data['ebook'] as Map<String, dynamic>?;
    final rawRelated = data['related_ebooks'] as List<dynamic>? ?? [];

    return EbookDetailResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString(),
      ebook: rawEbook != null ? EbookModel.fromJson(rawEbook) : null,
      relatedEbooks: rawRelated.map((e) => EbookModel.fromJson(e)).toList(),
    );
  }
}
