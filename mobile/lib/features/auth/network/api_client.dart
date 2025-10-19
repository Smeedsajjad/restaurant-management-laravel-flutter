import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final String baseUrl = 'http://backend.test/api';

  // ---------- Register ----------
  Future<Map<String, dynamic>?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      debugPrint("🔹 Sending request to $url");
      debugPrint("➡️ Data: name=$name, email=$email");

      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {'name': name, 'email': email, 'password': password},
      );

      debugPrint("📥 Response Code: ${response.statusCode}");
      debugPrint("📦 Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract and save token similar to login method
        final token =
            data['data']?['token'] as String? ?? data['token'] as String?;
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          debugPrint('✅ Token saved from registration: $token');
        } else {
          debugPrint('⚠️ Token missing in registration response');
        }
        return data;
      } else {
        return data;
      }
    } catch (e) {
      debugPrint("❌ Exception in register: $e");
      return null;
    }
  }

  // ---------- Login ----------
  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔹 Sending request to $baseUrl/login');
      debugPrint('➡️ Data: email=$email');

      final res = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password},
      );

      debugPrint('📥 Response Code: ${res.statusCode}');
      debugPrint('📦 Response Body: ${res.body}');

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        // Extract token safely
        final token = data['data']?['token'] as String?;
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          debugPrint('✅ Token saved: $token');
        } else {
          debugPrint('⚠️ Token missing in response');
        }

        return data;
      } else {
        debugPrint('Login failed: ${res.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Login error: $e');
      return null;
    }
  }

  // ---------- Logout ----------
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    debugPrint('🔹 Sending request to $baseUrl/logout');
    debugPrint('➡️ Data: token=$token');

    if (token == null) return;

    await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    await prefs.remove('token');
  }
}
