import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../view_model/register_view_model.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerState = ref.watch(registerViewModelProvider);
    final registerNotifier = ref.read(registerViewModelProvider.notifier);

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
                  "Create your\nnew account",
                  style: TextStyle(
                    fontSize: AppSizes.font4xl,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Create an account to start looking for the\nfood you like",
                  style: TextStyle(color: AppColors.grey400),
                ),
                const SizedBox(height: 25),

                // ===== FORM =====
                Form(
                  key: registerNotifier.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name
                      Text(
                        "Full name",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.fontMd,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: registerNotifier.nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'ⓘ Please enter your full name';
                          } else if (value.trim().length < 3) {
                            return 'ⓘ Name must be at least 3 characters';
                          }
                          return null;
                        },
                        onChanged: (_) => registerNotifier.checkFormValid(),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          labelText: 'Enter your name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Email
                      Text(
                        "Email address",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.fontMd,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: registerNotifier.emailController,
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
                        onChanged: (_) => registerNotifier.checkFormValid(),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
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
                        controller: registerNotifier.passwordController,
                        obscureText: registerState.passwordVisibility,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ⓘ Please enter a password';
                          } else if (value.length < 6) {
                            return 'ⓘ Password must be at least 6 characters';
                          }
                          return null;
                        },
                        onChanged: (_) => registerNotifier.checkFormValid(),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          labelText: 'Enter password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              registerState.passwordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed:
                                registerNotifier.togglePasswordVisibility,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Terms Checkbox
                      CheckboxListTile(
                        value: registerState.isChecked,
                        onChanged: (val) => registerNotifier.toggleTerms(val),
                        activeColor: AppColors.primary,
                        title: const Text(
                          "I Agree with Terms of Services",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 20),

                      if (registerState.errorMessage != null)
                        Text(
                          registerState.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),

                      const SizedBox(height: 25),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 62,
                        child: ElevatedButton(
                          onPressed: registerState.isValid
                              ? () => registerNotifier.register(context)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: registerState.isValid
                                ? AppColors.primary
                                : AppColors.grey300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: registerState.loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Register",
                                  style: TextStyle(
                                    color: registerState.isValid
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
