import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mobile/features/category/models/category_model.dart';
import 'package:mobile/features/category/viewmodels/category_repository.dart';

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
      state = AsyncValue.data(categories);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
