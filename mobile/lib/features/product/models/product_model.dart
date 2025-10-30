class ProductModel {
  final int id;
  final int categoryId;
  final String name;
  final String description;
  final String basePrice;
  final List<String> images;
  final bool isAvailable;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.images,
    required this.isAvailable,
  });
  
  String? get firstImage => images.isNotEmpty ? images.first : null;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'],
      basePrice: json['base_price'],
      images: List<String>.from(json['images'] ?? []),
      isAvailable: json['is_available'] ?? false,
    );
  }
}
