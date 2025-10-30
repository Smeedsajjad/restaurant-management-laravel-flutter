import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mobile/features/product/models/product_model.dart';
import '../repository/product_repository.dart';

final productViewModelProvider =
    StateNotifierProvider<ProductViewModel, AsyncValue<List<ProductModel>>>(
      (ref) => ProductViewModel(ProductRepository()),
    );

class ProductViewModel extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final ProductRepository _repository;

  ProductViewModel(this._repository) : super(const AsyncValue.loading()) {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      state = const AsyncValue.loading();
      final products = await _repository.fetchProducts();
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
