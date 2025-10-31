import 'package:mobile/features/product/models/product_model.dart';

class PaginatedProducts {
  final List<ProductModel> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String? next;
  final String? prev;

  PaginatedProducts({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.next,
    this.prev,
  });

  factory PaginatedProducts.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final itemsJson = data['data'] as List? ?? [];
    final meta = data['meta'] ?? {};
    final links = data['links'] ?? {};

    final items = itemsJson.map((e) => ProductModel.fromJson(e)).toList();

    return PaginatedProducts(
      items: items,
      currentPage: meta['current_page'] ?? 1,
      lastPage: meta['last_page'] ?? 1,
      perPage: meta['per_page'] ?? items.length,
      total: meta['total'] ?? items.length,
      next: links['next'],
      prev: links['prev'],
    );
  }
}
