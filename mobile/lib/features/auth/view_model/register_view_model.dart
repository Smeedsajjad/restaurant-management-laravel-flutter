import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import '../network/api_client.dart';

final registerViewModelProvider =
    StateNotifierProvider<RegisterViewModel, RegisterState>((ref) {
      return RegisterViewModel();
    });

class RegisterState {
  final bool passwordVisibility;
  final bool isChecked;
  final bool isValid;
  final bool loading;
  final String? errorMessage;

  RegisterState({
    this.passwordVisibility = true,
    this.isChecked = false,
    this.isValid = false,
    this.loading = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    bool? passwordVisibility,
    bool? isChecked,
    bool? isValid,
    bool? loading,
    String? errorMessage,
  }) {
    return RegisterState(
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      isChecked: isChecked ?? this.isChecked,
      isValid: isValid ?? this.isValid,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }
}

class RegisterViewModel extends StateNotifier<RegisterState> {
  RegisterViewModel() : super(RegisterState());

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void togglePasswordVisibility() {
    state = state.copyWith(passwordVisibility: !state.passwordVisibility);
  }

  void toggleTerms(bool? value) {
    state = state.copyWith(isChecked: value ?? false);
    checkFormValid();
  }

  void checkFormValid() {
    final isValid = formKey.currentState?.validate() ?? false;
    state = state.copyWith(isValid: isValid && state.isChecked);
  }

  Future<void> register(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    state = state.copyWith(loading: true, errorMessage: null);

    try {
      final res = await ApiClient().register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (res != null && res['success'] == true) {
        state = state.copyWith(loading: false);
        context.go('/home');
      } else {
        state = state.copyWith(
          loading: false,
          errorMessage: res?['message'] ?? 'Registration failed.',
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
