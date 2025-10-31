import 'package:flutter/material.dart';
import 'package:mobile/utils/constants/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.white,
      indicatorColor: AppColors.primary.withAlpha(75),
      selectedIndex: currentIndex,
      onDestinationSelected: onTabSelected,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      animationDuration: const Duration(milliseconds: 300),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(
          // color: Colors.black54,
          // fontWeight: FontWeight.w500,
        );
      }),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: AppColors.primary),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(Icons.shopping_cart, color: AppColors.primary),
          label: 'Cart',
        ),
        NavigationDestination(
          icon: Icon(Icons.fastfood_outlined),
          selectedIcon: Icon(Icons.fastfood, color: AppColors.primary),
          label: 'Products',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long, color: AppColors.primary),
          label: 'Orders',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person, color: AppColors.primary),
          label: 'Profile',
        ),
      ],
    );
  }
}
