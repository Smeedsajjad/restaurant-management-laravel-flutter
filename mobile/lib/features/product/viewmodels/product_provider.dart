import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mobile/features/product/models/paginated_products.dart';
import '../repository/product_repository.dart';

final productViewModelProvider =
    StateNotifierProvider<ProductViewModel, AsyncValue<PaginatedProducts>>(
      (ref) => ProductViewModel(ProductRepository()),
    );

class ProductViewModel extends StateNotifier<AsyncValue<PaginatedProducts>> {
  final ProductRepository _repository;
  final int _perPage = 8;

  ProductViewModel(this._repository) : super(const AsyncValue.loading()) {
    fetchPage(1);
  }

  Future<void> fetchPage(int page) async {
    try {
      state = const AsyncValue.loading();
      final paginated = await _repository.fetchProducts(
        page: page,
        perPage: _perPage,
      );
      state = AsyncValue.data(paginated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> goToPage(int page) async => fetchPage(page);

  Future<void> nextPage() async {
    final current = state.hasValue ? state.value : null;
    if (current == null) return;
    if (current.currentPage < current.lastPage) {
      await fetchPage(current.currentPage + 1);
    }
  }

  Future<void> prevPage() async {
    final current = state.hasValue ? state.value : null;
    if (current == null) return;
    if (current.currentPage > 1) {
      await fetchPage(current.currentPage - 1);
    }
  }
}
