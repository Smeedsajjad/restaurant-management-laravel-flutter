import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mobile/features/category/models/category_model.dart';
import 'package:mobile/features/category/viewmodels/category_repository.dart';
import 'package:flutter/foundation.dart';

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, AsyncValue<List<CategoryModel>>>(
      (ref) => CategoryNotifier(CategoryRepository()),
    );

class CategoryNotifier extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  final CategoryRepository repository;

  CategoryNotifier(this.repository) : super(const AsyncValue.loading()) {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      state = const AsyncValue.loading();
      final categories = await repository.fetchCategories();
      // Always set data (can be empty) so UI can display a fallback
      state = AsyncValue.data(categories);
    } catch (e, st) {
      debugPrint('CategoryNotifier: fetch error: $e\n$st');
      // On unexpected exceptions, expose empty list instead of error
      state = const AsyncValue.data([]);
    }
  }
}
