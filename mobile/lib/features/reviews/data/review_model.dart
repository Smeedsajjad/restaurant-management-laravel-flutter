class ProductReviewModel {
  final int id;
  final int rating;
  final String comment;
  final String createdAt;
  final UserModel user;
  final MenuItemModel menuItem;

  ProductReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.user,
    required this.menuItem,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewModel(
      id: json['id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['created_at'],
      user: UserModel.fromJson(json['user']),
      menuItem: MenuItemModel.fromJson(json['menu_item']),
    );
  }
}

class UserModel {
  final int id;
  final String name;

  UserModel({required this.id, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(id: json['id'], name: json['name']);
}

class MenuItemModel {
  final int id;
  final String name;

  MenuItemModel({required this.id, required this.name});

  factory MenuItemModel.fromJson(Map<String, dynamic> json) =>
      MenuItemModel(id: json['id'], name: json['name']);
}
