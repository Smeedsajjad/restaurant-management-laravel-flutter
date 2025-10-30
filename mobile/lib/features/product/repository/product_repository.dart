import 'dart:convert';
import 'package:mobile/features/product/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  final String baseUrl = 'http://backend.test/api/v1/menu-items';

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final url = Uri.parse(baseUrl);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List products = decoded['data']['data'] ?? [];
        return products.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
