import 'package:flutter/material.dart';
import 'package:mobile/features/home/views/home_view.dart';
import 'package:mobile/utils/constants/app_colors.dart';

void main() {
  runApp(const TaastyApp());
}

class TaastyApp extends StatelessWidget {
  const TaastyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      themeMode: ThemeMode.light,
      home: HomeView(),
    );
  }
}
