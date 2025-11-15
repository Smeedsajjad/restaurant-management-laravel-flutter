import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/review_model.dart';

class ReviewService {
  final String baseUrl = 'http://backend.test/api/v1';

  Future<List<ProductReviewModel>> fetchReviews(int menuItemId) async {
    final response = await http.get(Uri.parse('$baseUrl/menu-items/$menuItemId/reviews'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> list = data['data'];
      return list.map((json) => ProductReviewModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }
}
