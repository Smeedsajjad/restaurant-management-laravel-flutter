import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import './register_screen.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../network/api_client.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisibility = true;
  final _formKey = GlobalKey<FormState>();
  bool _isValid = false;
  bool loading = false;
  String? _errorMessage;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _api = ApiClient();

  void _checkFormValid() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() => _isValid = isValid);
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
      _errorMessage = null;
    });

    try {
      final res = await _api.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() => loading = false);

      if (!mounted) return;

      if (res != null) {
        showModalBottomSheet(
          context: context,
          isDismissible: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          builder: (context) => Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 80),
                SizedBox(height: 16),
                Text(
                  "Login Successful!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Welcome! Redirecting to home...",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pop(context);
          context.go('/home');
        }
      } else {
        setState(() {
          _errorMessage = res?['message'] ?? 'Invalid Cerdentials.';
        });
      }
    } catch (e) {
      // 🌐 Network or unexpected error
      setState(() {
        loading = false;
        _errorMessage = 'Something went wrong. Please check your connection.';
      });

      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        builder: (context) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, color: Colors.orange, size: 80),
              const SizedBox(height: 16),
              const Text(
                "Network Error",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(_errorMessage!),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          toolbarHeight: 75,
          leadingWidth: 100,
          leading: Image.asset("assets/images/logo.png", fit: BoxFit.contain),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.grey300, width: 2),
                ),
                child: const Icon(
                  Icons.question_mark_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Login to\nyour account",
                  style: TextStyle(
                    fontSize: AppSizes.font4xl,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Welcome back, you've been missed!",
                  style: TextStyle(color: AppColors.grey400),
                ),
                const SizedBox(height: 25),

                // ===== FORM =====
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email
                      Text(
                        "Email",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.fontMd,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'ⓘ Email required' : null,
                        onChanged: (_) => _checkFormValid(),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          labelText: 'Enter email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: AppColors.grey300,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: AppColors.grey300,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: AppColors.grey300,
                              width: 1.0,
                            ),
                          ),

                          errorStyle: TextStyle(color: AppColors.secondary),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: AppColors.secondary,
                              width: 2.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: AppColors.secondary,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Password
                      Text(
                        "Password",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.fontMd,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _passwordVisibility,
                        validator: (v) => v == null || v.isEmpty
                            ? 'ⓘ Password required'
                            : null,
                        onChanged: (_) => _checkFormValid(),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          labelText: 'Enter password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () => setState(
                              () => _passwordVisibility = !_passwordVisibility,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: AppColors.grey300,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: AppColors.grey300,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: AppColors.grey300,
                              width: 1.0,
                            ),
                          ),

                          errorStyle: TextStyle(color: AppColors.secondary),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: AppColors.secondary,
                              width: 2.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: AppColors.secondary,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 62,
                        child: ElevatedButton(
                          onPressed: _isValid ? login : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isValid
                                ? AppColors.primary
                                : AppColors.grey300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                    color: _isValid
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: AppColors.grey400),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      ),
                      child: Text(
                        "Register",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
