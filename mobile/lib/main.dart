import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/view/login_screen.dart';
import 'package:mobile/features/auth/view/register_screen.dart';
import 'package:mobile/features/reviews/views/review_view.dart';
import 'package:mobile/utils/constants/app_colors.dart';
import 'package:mobile/utils/core/widgets/app_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final isLoggedIn = token != null && token.isNotEmpty;
  runApp(ProviderScope(child: TaastyApp(isLoggedIn: isLoggedIn)));
}

class TaastyApp extends StatelessWidget {
  final bool isLoggedIn;

  const TaastyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const AppShell(),
        ),
        GoRoute(
          path: '/reviews/:menuItemId',
          name: 'reviews',
          builder: (context, state) {
            final menuItemId = int.parse(state.pathParameters['menuItemId']!);
            return ReviewView(productId: menuItemId);
          },
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Taasty App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
