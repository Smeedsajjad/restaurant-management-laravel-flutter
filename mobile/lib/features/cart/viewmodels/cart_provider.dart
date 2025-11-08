import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mobile/features/cart/models/cart_item_model.dart';
import 'package:mobile/features/cart/repository/cart_repository.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, AsyncValue<List<CartItemModel>>>(
      (ref) => CartNotifier(CartRepository()),
    );

class CartNotifier extends StateNotifier<AsyncValue<List<CartItemModel>>> {
  final CartRepository _repo;

  CartNotifier(this._repo) : super(const AsyncValue.loading()) {
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      state = const AsyncValue.loading();
      final items = await _repo.fetchCart();
      state = AsyncValue.data(items);
    } on NotAuthenticatedException {
      state = const AsyncValue.data([]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addToCart({required int menuItemId, int quantity = 1}) async {
    try {
      await _repo.addToCart(menuItemId: menuItemId, quantity: quantity);
      await loadCart();
    } on NotAuthenticatedException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateItem({required int cartId, required int quantity}) async {
    try {
      await _repo.updateCartItem(cartId: cartId, quantity: quantity);
      await loadCart();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeItem({required int cartId}) async {
    try {
      await _repo.removeCartItem(cartId: cartId);
      await loadCart();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearAll() async {
    try {
      await _repo.clearCart();
      await loadCart();
    } catch (e) {
      rethrow;
    }
  }
}
