import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../core/utils/app_snackbar.dart';

class AuthController extends GetxController {
  final isLogin = true.obs; // start on Login

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final obscurePassword = true.obs;

  void toggleMode() {
    isLogin.value = !isLogin.value;
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

    AppSnackbar.success(
      'Success',
      isLogin.value ? 'Logged in successfully' : 'Account created successfully',
    );

    Get.offNamed(
      AppRoutes.profileSetup,
      arguments: {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
      },
    );
  }

  Future<void> continueWithGoogle() async {
    AppSnackbar.info('Google', 'Google Sign-In coming soon');
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
