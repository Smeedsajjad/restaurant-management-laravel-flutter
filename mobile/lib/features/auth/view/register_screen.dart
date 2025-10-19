import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login_screen.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../network/api_client.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisibility = true;
  bool _isChecked = false;
  bool _isValid = false;
  bool _loading = false;
  String? _errorMessage;
  final _api = ApiClient();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  void _checkFormValid() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() {
      _isValid = isValid && _isChecked;
    });
  }

  Future<void> register() async {
    setState(() {
      _errorMessage = null;
      _loading = true;
    });

    try {
      final res = await _api.register(
        name: _name.text.trim(),
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      setState(() => _loading = false);
      if (!mounted) return;

      if (res == null) {
        _showErrorModal("No response from server. Please try again.");
        return;
      }

      if (res['error'] != null) {
        final error = res['error'];
        String message = error['message'] ?? 'Registration failed.';

        if (error['details'] != null && error['details'] is Map) {
          final details = error['details'] as Map;
          if (details.isNotEmpty) {
            final firstField = details.keys.first;
            final firstMessage = (details[firstField] as List).first;
            message = firstMessage;
          }
        }

        setState(() => _errorMessage = message);
        _showErrorModal(message);
        return;
      }

      // Check for success with proper token extraction
      final token = res['data']?['token'] ?? res['token'];
      final isSuccess = res['success'] == true || token != null;

      if (isSuccess) {
        _showSuccessModal();

        final prefs = await SharedPreferences.getInstance();
        final savedToken = prefs.getString('token');
        debugPrint('🔍 Token verification - Saved: ${savedToken != null}');

        if (savedToken != null) {
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            debugPrint('🔄 Redirecting to home...');
            context.go('/home');
          }
        } else {
          _showErrorModal('Authentication failed. Please login manually.');
        }
      } else {
        _showErrorModal(
          res['message'] ?? 'Registration failed. Please try again.',
        );
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'Something went wrong. Please check your connection.';
      });
      _showErrorModal(_errorMessage!);
    }
  }

  void _showErrorModal(String message) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 80),
            const SizedBox(height: 16),
            const Text(
              "Registration Failed!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessModal() {
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
              "Registration Successful!",
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
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
                  border: Border.all(color: AppColors.grey300, width: 12),
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
                  "Create your\nnew account",
                  style: TextStyle(
                    fontSize: AppSizes.font4xl,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Create an account to start looking fot the\nfood you like",
                  style: TextStyle(color: AppColors.grey400),
                ),
                SizedBox(height: 25),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Full name",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.fontMd,
                        ),
                      ),
                      SizedBox(height: 10),

                      TextFormField(
                        controller: _name,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Enter your name',
                          labelStyle: TextStyle(color: AppColors.grey300),
                          filled: true,
                          fillColor: Colors.white,
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
                        onChanged: (_) => _checkFormValid(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'ⓘ Please enter your full name';
                          } else if (value.trim().length < 3) {
                            return 'ⓘ Name must be at least 3 characters';
                          }
                          return null;
                        },
                      ),

                      Text(
                        "Email address",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.fontMd,
                        ),
                      ),
                      SizedBox(height: 10),

                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Enter email',
                          labelStyle: TextStyle(color: AppColors.grey300),
                          filled: true,
                          fillColor: Colors.white,
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
                        controller: _email,
                        onChanged: (_) => _checkFormValid(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ⓘ Please enter your email';
                          }
                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegex.hasMatch(value)) {
                            return 'ⓘ Enter a valid email address';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 15),
                      Text(
                        "Password",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.fontMd,
                        ),
                      ),
                      SizedBox(height: 10),

                      TextFormField(
                        obscureText: _passwordVisibility,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: "Enter Password",
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _passwordVisibility = !_passwordVisibility;
                              });
                            },
                            child: _passwordVisibility
                                ? Icon(Icons.visibility_outlined)
                                : Icon(Icons.visibility_off_outlined),
                          ),
                          labelStyle: TextStyle(color: AppColors.grey300),
                          filled: true,
                          fillColor: Colors.white,

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
                        controller: _password,
                        onChanged: (_) => _checkFormValid(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ⓘ Please enter a password';
                          } else if (value.length < 6) {
                            return 'ⓘ Password must be at least 6 characters';
                          }
                          final strongPass = RegExp(
                            r'^(?=.*[0-9])(?=.*[!@#\$%^&*])',
                          );
                          if (!strongPass.hasMatch(value)) {
                            return 'ⓘ Must include a number & special character';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 10),
                      CheckboxListTile(
                        value: _isChecked,
                        onChanged: (val) {
                          setState(() {
                            _isChecked = val ?? false;
                            _checkFormValid();
                          });
                        },
                        activeColor: AppColors.primary,
                        title: Text(
                          "I Agree with Terms of Services",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
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
                          onPressed: _isValid ? register : null,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isValid
                                ? AppColors.primary
                                : AppColors.grey300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Register",
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
                Container(
                  height: 0.75,
                  width: double.infinity,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(vertical: 30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: const Icon(
                        FontAwesomeIcons.google,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: const Icon(
                        FontAwesomeIcons.apple,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: const Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already Have an account",
                        style: TextStyle(color: AppColors.grey400),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
