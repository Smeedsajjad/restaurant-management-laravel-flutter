import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/review_model.dart';
import '../repository/review_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final reviewNotifierProvider =
    StateNotifierProvider<ReviewNotifier, AsyncValue<List<ProductReviewModel>>>(
      (ref) => ReviewNotifier(
        repository: ReviewRepository('http://backend.test/api/v1'),
      ),
    );

class ReviewNotifier
    extends StateNotifier<AsyncValue<List<ProductReviewModel>>> {
  final ReviewRepository repository;

  ReviewNotifier({required this.repository})
    : super(const AsyncValue.loading());

  Future<void> loadReviews(int productId) async {
    state = const AsyncValue.loading();
    try {
      final reviews = await repository.fetchReviews(productId);
      state = AsyncValue.data(reviews);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> submitReview({
    required int menuItemId,
    required double rating,
    required String comment,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('You are not logged in. Please log in to add a review.');
    }

    final res = await http.post(
      Uri.parse('http://backend.test/api/v1/reviews'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "menu_item_id": menuItemId,
        "rating": rating.toInt(),
        "comment": comment,
      }),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      await loadReviews(menuItemId);
      return;
    } else if (res.statusCode == 401) {
      throw Exception('Your session has expired. Please log in again.');
    }

    throw Exception("Failed to submit review: ${res.statusCode} ${res.body}");
  }
}
