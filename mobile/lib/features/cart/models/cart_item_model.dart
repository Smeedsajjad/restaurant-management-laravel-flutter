class MenuItemLite {
  final int id;
  final String name;
  final double? price;

  MenuItemLite({required this.id, required this.name, this.price});

  factory MenuItemLite.fromJson(Map<String, dynamic> json) {
    return MenuItemLite(
      id: json['id'] as int,
      name: (json['name'] ?? '') as String,
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
    );
  }
}

class CartItemModel {
  final int id;
  final MenuItemLite menuItem;
  final int quantity;
  final double subtotal;

  CartItemModel({
    required this.id,
    required this.menuItem,
    required this.quantity,
    required this.subtotal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final menuItemJson = json['menu_item'] as Map<String, dynamic>? ?? {};
    return CartItemModel(
      id: json['id'] as int,
      menuItem: MenuItemLite.fromJson(menuItemJson),
      quantity: (json['quantity'] ?? 1) as int,
      subtotal: json['subtotal'] != null
          ? double.tryParse(json['subtotal'].toString()) ?? 0.0
          : 0.0,
    );
  }
}
