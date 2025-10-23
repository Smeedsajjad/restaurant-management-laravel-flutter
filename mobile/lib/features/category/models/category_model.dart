class CategoryModel {
  final int id;
  final String name;
  final String emoji;
  final int isActive;
  final int position;

  CategoryModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.isActive,
    required this.position,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'] ?? '',
      emoji: json['emoji'] ?? '🍽️',
      isActive: json['is_active'] ?? 0,
      position: json['position'] ?? 0,
    );
  }
}
