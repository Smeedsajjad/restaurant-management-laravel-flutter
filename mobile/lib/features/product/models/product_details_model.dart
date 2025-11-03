class ModifierOptionModel {
  final int id;
  final String name;
  final String price;

  ModifierOptionModel({
    required this.id,
    required this.name,
    required this.price,
  });

  factory ModifierOptionModel.fromJson(Map<String, dynamic> json) {
    return ModifierOptionModel(
      id: json['id'],
      name: json['name'],
      price: json['price']?.toString() ?? '0.00',
    );
  }
}

class ModifierModel {
  final int id;
  final String name;
  final bool required;
  final List<ModifierOptionModel> options;

  ModifierModel({
    required this.id,
    required this.name,
    required this.required,
    required this.options,
  });

  factory ModifierModel.fromJson(Map<String, dynamic> json) {
    final opts =
        (json['options'] as List?)
            ?.map(
              (e) => ModifierOptionModel.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        [];
    return ModifierModel(
      id: json['id'],
      name: json['name'] ?? '',
      required: json['required'] ?? false,
      options: opts,
    );
  }
}

class ReviewModel {
  final int id;
  final String userName;
  final int rating;
  final String comment;

  ReviewModel({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      userName: json['user_name'] ?? 'Guest',
      rating: (json['rating'] ?? 0) as int,
      comment: json['comment'] ?? '',
    );
  }
}

class ProductDetailsModel {
  final int id;
  final int categoryId;
  final String categoryName;
  final String name;
  final String description;
  final String basePrice;
  final List<String> images;
  final bool isAvailable;
  final List<ReviewModel> reviews;
  final List<ModifierModel> modifiers;
  final double averageRating;

  ProductDetailsModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.images,
    required this.isAvailable,
    this.reviews = const [],
    this.modifiers = const [],
    this.averageRating = 0.0,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    final reviewsJson = (json['reviews'] as List?) ?? [];
    final modifiersJson = (json['modifiers'] as List?) ?? [];

    final reviews = reviewsJson
        .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final modifiers = modifiersJson
        .map((e) => ModifierModel.fromJson(e as Map<String, dynamic>))
        .toList();

    double avg = 0.0;
    if (reviews.isNotEmpty) {
      avg =
          reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
    }

    return ProductDetailsModel(
      id: json['id'],
      categoryId: json['category_id'],
      categoryName: json['category_name'] ?? 'Uncategorized',
      name: json['name'],
      description: json['description'] ?? '',
      basePrice: json['base_price']?.toString() ?? '0.00',
      images: List<String>.from(json['images'] ?? []),
      isAvailable: json['is_available'] ?? false,
      reviews: reviews,
      modifiers: modifiers,
      averageRating: avg,
    );
  }
}
