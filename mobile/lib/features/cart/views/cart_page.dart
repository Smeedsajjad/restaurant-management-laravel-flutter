import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/cart/viewmodels/cart_provider.dart';
import 'package:mobile/utils/constants/app_colors.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Color(0xFF2D3142),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: cartState.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            );
          }
          final total = items.fold<double>(0.0, (p, e) => p + e.subtotal);
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final it = items[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primary,
                              child: Text(
                                it.menuItem.name.isNotEmpty
                                    ? it.menuItem.name[0]
                                    : 'M',
                                style: TextStyle(color: AppColors.primary),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    it.menuItem.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '\$${it.menuItem.price?.toStringAsFixed(2) ?? (it.subtotal / (it.quantity)).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                        ),
                                        onPressed: it.quantity > 1
                                            ? () => ref
                                                  .read(cartProvider.notifier)
                                                  .updateItem(
                                                    cartId: it.id,
                                                    quantity: it.quantity - 1,
                                                  )
                                            : null,
                                      ),
                                      Text(
                                        '${it.quantity}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                        ),
                                        onPressed: () => ref
                                            .read(cartProvider.notifier)
                                            .updateItem(
                                              cartId: it.id,
                                              quantity: it.quantity + 1,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${it.subtotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => ref
                                      .read(cartProvider.notifier)
                                      .removeItem(cartId: it.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () {
                        // Checkout not implemented yet
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Checkout not implemented'),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text('Checkout'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () =>
                          ref.read(cartProvider.notifier).clearAll(),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
