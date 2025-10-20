import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import '../network/api_client.dart';

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
      return LoginViewModel();
    });

class LoginState {
  final bool passwordVisibility;
  final bool isValid;
  final bool loading;
  final String? errorMessage;

  LoginState({
    this.passwordVisibility = true,
    this.isValid = false,
    this.loading = false,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? passwordVisibility,
    bool? isValid,
    bool? loading,
    String? errorMessage,
  }) {
    return LoginState(
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      isValid: isValid ?? this.isValid,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }
}

class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel() : super(LoginState());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void togglePasswordVisibility() {
    state = state.copyWith(passwordVisibility: !state.passwordVisibility);
  }

  void checkFormValid() {
    final isValid = formKey.currentState?.validate() ?? false;
    state = state.copyWith(isValid: isValid);
  }

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    state = state.copyWith(loading: true, errorMessage: null);

    try {
      final res = await ApiClient().login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (res != null) {
        state = state.copyWith(loading: false);
        context.go('/home');
      } else {
        state = state.copyWith(
          loading: false,
          errorMessage: 'Invalid credentials.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        loading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }
}
