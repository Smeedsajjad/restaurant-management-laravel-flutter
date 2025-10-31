import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/category_notifier.dart';
import 'package:mobile/utils/constants/app_colors.dart';

class CategorySection extends ConsumerWidget {
  const CategorySection({super.key});

  static const List<String> _defaultEmojis = ['🍕', '🍔', '🥤', '🍰', '🥗'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);

    return categoriesAsync.when(
      data: (categories) {
        final hasCategories = categories.isNotEmpty;
        final itemCount = hasCategories
            ? categories.length
            : _defaultEmojis.length;

        return SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final emoji = hasCategories
                  ? categories[index].emoji
                  : _defaultEmojis[index];
              return Container(
                width: 60,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8CC),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryVariant),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 32)),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) {
        // On state-level errors, also show the emoji fallback rather than an error UI
        return SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _defaultEmojis.length,
            itemBuilder: (context, index) {
              return Container(
                width: 60,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8CC),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryVariant),
                ),
                child: Center(
                  child: Text(
                    _defaultEmojis[index],
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
