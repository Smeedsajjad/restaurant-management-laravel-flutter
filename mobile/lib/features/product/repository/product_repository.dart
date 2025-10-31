import 'dart:convert';
import 'package:mobile/features/product/models/paginated_products.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  final String baseUrl = 'http://backend.test/api/v1/menu-items';

  Future<PaginatedProducts> fetchProducts({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final uri = Uri.parse(baseUrl).replace(
        queryParameters: {
          'page': page.toString(),
          'per_page': perPage.toString(),
        },
      );

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return PaginatedProducts.fromJson(decoded);
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
