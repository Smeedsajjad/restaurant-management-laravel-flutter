import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../view_model/login_view_model.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider);
    final loginNotifier = ref.read(loginViewModelProvider.notifier);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          toolbarHeight: 75,
          leadingWidth: 100,
          leading: Image.asset("assets/images/logo.png", fit: BoxFit.contain),
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
                  key: loginNotifier.formKey,
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
                        controller: loginNotifier.emailController,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'ⓘ Email required' : null,
                        onChanged: (_) => loginNotifier.checkFormValid(),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          labelText: 'Enter email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
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
                        controller: loginNotifier.passwordController,
                        obscureText: loginState.passwordVisibility,
                        validator: (v) => v == null || v.isEmpty
                            ? 'ⓘ Password required'
                            : null,
                        onChanged: (_) => loginNotifier.checkFormValid(),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          labelText: 'Enter password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              loginState.passwordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: loginNotifier.togglePasswordVisibility,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (loginState.errorMessage != null)
                        Text(
                          loginState.errorMessage!,
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
                          onPressed: loginState.isValid
                              ? () => loginNotifier.login(context)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: loginState.isValid
                                ? AppColors.primary
                                : AppColors.grey300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: loginState.loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                    color: loginState.isValid
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
                      onPressed: () => context.go('/register'),
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
