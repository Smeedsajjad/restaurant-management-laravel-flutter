import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/category_notifier.dart';
import 'package:mobile/utils/constants/app_colors.dart';

class CategorySection extends ConsumerWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);

    return categoriesAsync.when(
      data: (categories) => SizedBox(
        height: 70,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return Container(
              width: 60,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE8CC),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryVariant),
              ),
              child: Center(
                child: Text(cat.emoji, style: const TextStyle(fontSize: 32)),
              ),
            );
          },
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}
