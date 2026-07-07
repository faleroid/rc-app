class AcademyModule {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String duration;
  final String level;
  final bool isLocked;

  const AcademyModule({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.duration,
    required this.level,
    this.isLocked = false,
  });

  /// Factory method to create a module from JSON/Map in the future
  factory AcademyModule.fromJson(Map<String, dynamic> json) {
    return AcademyModule(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      level: json['level'] as String? ?? 'Beginner',
      isLocked: json['isLocked'] as bool? ?? false,
    );
  }

  /// Convert to JSON for compatibility with future API integration
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': imageUrl,
      'duration': duration,
      'level': level,
      'isLocked': isLocked,
    };
  }
}
