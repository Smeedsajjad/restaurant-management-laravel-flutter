import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/category/views/category_section.dart';
import 'package:mobile/utils/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? userName;
  bool _loggedIn = false; // added

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      setState(() {
        userName = 'Guest';
        _loggedIn = false;
      });
      return;
    }

    try {
      final res = await http.get(
        Uri.parse('http://backend.test/api/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          userName = data['name'] ?? 'Guest';
          _loggedIn = true;
        });
      } else {
        setState(() {
          userName = 'Guest';
          _loggedIn = false;
        });
      }
    } catch (e) {
      setState(() {
        userName = 'Guest';
        _loggedIn = false;
      });
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    // if user isn't logged in, inform them and optionally navigate to login
    if (!_loggedIn) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('You are not logged in')));
      // optional: navigate to login
      // context.go('/login');
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _performLogout(context);
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      debugPrint('🧹 Token removed. Logging out...');
      setState(() {
        userName = 'Guest';
        _loggedIn = false;
      });

      if (!mounted) return;
      await _showLogoutSuccessModal(context);
    } catch (e) {
      debugPrint('❌ Logout error: $e');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      setState(() {
        userName = 'Guest';
        _loggedIn = false;
      });
      if (!mounted) return;
      await _showLogoutSuccessModal(context);
    }
  }

  Future<void> _showLogoutSuccessModal(BuildContext context) async {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logout successful — redirecting to login...'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildTitle(),
                    const SizedBox(height: 20),
                    _buildPromoCard(),
                    const SizedBox(height: 24),
                    const CategorySection(),
                    const SizedBox(height: 24),
                    _buildRecommendedSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi $userName 👋',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Welcome to Taasty!',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: GestureDetector(
                  onTap: () => context.push('/search'),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.search, color: Colors.black87),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 12),

              PopupMenuButton<int>(
                tooltip: '',
                offset: const Offset(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => _loggedIn
                    ? [
                        const PopupMenuItem(value: 1, child: Text('Profile')),
                        const PopupMenuItem(value: 2, child: Text('Logout')),
                      ]
                    : [const PopupMenuItem(value: 3, child: Text('Login'))],
                onSelected: (value) {
                  if (value == 1) {
                    context.go('/profile');
                  } else if (value == 2) {
                    _confirmLogout(context);
                  } else if (value == 3) {
                    context.go('/login');
                  }
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'Providing the best\nfoods for you! 🍲',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _buildPromoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFB84D), AppColors.primary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -35,
              bottom: -60,
              child: Image.asset(
                'assets/images/pizza_card.png',
                width: 220,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Happy Sunday',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Get 50%+ Discount!',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD2691E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Get Now',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recommended for you',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildFoodCard(
                'Greek Salad',
                'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=300',
                4.5,
              ),
              _buildFoodCard(
                'Ramen Tastyum',
                'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=300',
                4.8,
              ),
              _buildFoodCard(
                'Mix Gre',
                'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300',
                4.6,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFoodCard(String name, String imageUrl, double rating) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  imageUrl,
                  width: 160,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 160,
                    height: 140,
                    color: Colors.grey[300],
                    child: const Icon(Icons.restaurant, size: 50),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Text('⚡', style: TextStyle(fontSize: 16)),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
