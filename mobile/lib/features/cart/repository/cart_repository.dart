import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';

class NotAuthenticatedException implements Exception {
  final String message;
  NotAuthenticatedException([this.message = 'Not authenticated']);
  @override
  String toString() => message;
}

class CartRepository {
  final String baseUrl = 'http://backend.test/api/v1/cart';

  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) throw NotAuthenticatedException();
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<CartItemModel>> fetchCart() async {
    final headers = await _authHeaders();
    final uri = Uri.parse(baseUrl);
    final res = await http.get(uri, headers: headers);
    if (res.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(res.body) as Map<String, dynamic>;
      final data = decoded['data'];
      final list = (data as List?) ?? [];
      return list.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to fetch cart: ${res.statusCode}');
  }

  Future<CartItemModel> addToCart({required int menuItemId, int quantity = 1}) async {
    final headers = await _authHeaders();
    final uri = Uri.parse(baseUrl);
    final res = await http.post(
      uri,
      headers: {
        ...headers,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'menu_item_id': menuItemId,
        'quantity': quantity,
      }),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final Map<String, dynamic> decoded = jsonDecode(res.body) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>;
      return CartItemModel.fromJson(data);
    }
    if (res.statusCode == 401) throw NotAuthenticatedException();
    throw Exception('Failed to add to cart: ${res.statusCode} - ${res.body}');
  }

  Future<CartItemModel> updateCartItem({required int cartId, required int quantity}) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('$baseUrl/$cartId');
    final res = await http.put(
      uri,
      headers: {
        ...headers,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'quantity': quantity}),
    );
    if (res.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(res.body) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>;
      return CartItemModel.fromJson(data);
    }
    throw Exception('Failed to update cart item: ${res.statusCode}');
  }

  Future<void> removeCartItem({required int cartId}) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('$baseUrl/$cartId');
    final res = await http.delete(uri, headers: headers);
    if (res.statusCode == 200) return;
    throw Exception('Failed to remove cart item: ${res.statusCode}');
  }

  Future<void> clearCart() async {
    final headers = await _authHeaders();
    final uri = Uri.parse('http://backend.test/api/v1/cart-clear');
    final res = await http.delete(uri, headers: headers);
    if (res.statusCode == 200) return;
    throw Exception('Failed to clear cart: ${res.statusCode}');
  }
}