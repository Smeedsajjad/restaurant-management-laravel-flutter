import 'package:flutter/material.dart';
import 'package:mobile/features/home/views/home_view.dart';
import 'package:mobile/utils/core/navigation/app_bottom_nav.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
    int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeView(),
    SizedBox(),
    SizedBox(),
    SizedBox(),
    SizedBox(),
  ];

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}