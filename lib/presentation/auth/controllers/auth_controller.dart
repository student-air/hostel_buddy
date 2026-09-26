import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final isLogin = false.obs; // false = Sign up, true = Log in

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final obscurePassword = true.obs;

  void toggleMode() {
    isLogin.value = !isLogin.value;
    // Clear fields when switching
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // simulate API
    isLoading.value = false;

    // TODO: Navigate to Role Selection / next screen
    Get.snackbar(
      'Success',
      isLogin.value ? 'Logged in successfully' : 'Account created successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF6B0E24),
      colorText: Colors.white,
    );
  }

  Future<void> continueWithGoogle() async {
    Get.snackbar(
      'Google',
      'Google Sign-In coming soon',
      snackPosition: SnackPosition.TOP,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
