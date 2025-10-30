import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/product/views/product_list_view.dart';
import 'package:mobile/utils/constants/app_colors.dart';

void main() {
  runApp(ProviderScope(child: const TaastyApp()));
}

class TaastyApp extends StatelessWidget {
  const TaastyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: const ProductListView(),
    );
  }
}
