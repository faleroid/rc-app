class CardModel {
  final String title;
  final String description;
  final String imageUrl;
  final String status;

  const CardModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.status = "Free",
  });
}
