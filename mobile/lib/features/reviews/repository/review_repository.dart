import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/review_model.dart';

class ReviewRepository {
  final String baseUrl;

  ReviewRepository(this.baseUrl);

  Future<List<ProductReviewModel>> fetchReviews(int productId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/menu-items/$productId/reviews'),
    );

    if (res.statusCode == 200) {
      final jsonBody = jsonDecode(res.body);
      final List<dynamic> data = jsonBody['data'];
      return data.map((item) => ProductReviewModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }
}
