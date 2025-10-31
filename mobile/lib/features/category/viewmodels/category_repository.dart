import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/features/category/models/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryRepository {
  final String baseUrl = 'http://backend.test/api/v1/categories';

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final res = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List<dynamic> list = data['data'] ?? [];

        return list
            .map((json) => CategoryModel.fromJson(json))
            .where((cat) => cat.isActive == 1)
            .toList();
      } else {
        debugPrint('CategoryRepository: failed status ${res.statusCode}');
        // Return empty list so UI can show fallback instead of throwing
        return [];
      }
    } catch (e, st) {
      debugPrint('CategoryRepository: error fetching categories: $e\n$st');
      // Return empty list when network / parsing fails
      return [];
    }
  }
}
