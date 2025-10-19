import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/view/login_screen.dart';
import 'package:mobile/features/auth/view/register_screen.dart';
import 'package:mobile/features/home/views/home_view.dart';
import 'package:mobile/utils/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final isLoggedIn = token != null && token.isNotEmpty;
  runApp(TaastyApp(isLoggedIn: isLoggedIn));
}

class TaastyApp extends StatelessWidget {
  final bool isLoggedIn;

  const TaastyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: isLoggedIn ? '/home' : '/login',
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
          builder: (context, state) => const HomeView(),
        ),
      ],
      redirect: (context, state) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        final loggedIn = token != null && token.isNotEmpty;

        final isAuthRoute =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        debugPrint(
          '🔄 Router Redirect - Location: ${state.matchedLocation}, LoggedIn: $loggedIn',
        );

        if (!loggedIn && !isAuthRoute) {
          return '/login';
        }

        if (loggedIn && isAuthRoute) {
          return '/home';
        }

        return null;
      },
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
